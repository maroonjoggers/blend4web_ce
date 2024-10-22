#version GLSL_VERSION

/*==============================================================================
                            VARS FOR THE COMPILER
==============================================================================*/
#var AU_QUALIFIER uniform
#var PRECISION lowp
#var MAX_BONES 0

/*==============================================================================
                                  INCLUDES
==============================================================================*/

#include <math.glslv>
#include <to_world.glslv>

/*==============================================================================
                                SHADER INTERFACE
==============================================================================*/
GLSL_IN vec3 a_position;
GLSL_IN vec3 a_normal;
GLSL_IN float a_polyindex;

#if USE_INSTANCED_PARTCLS
GLSL_IN vec4 a_part_ts;
GLSL_IN vec4 a_part_r;
#endif

#if !DEBUG_SPHERE
# if WIND_BEND
#  if MAIN_BEND_COL
GLSL_IN float a_bending_col_main;
#   if DETAIL_BEND
GLSL_IN vec3 a_bending_col_detail;
AU_QUALIFIER float au_detail_bending_amp;
AU_QUALIFIER float au_branch_bending_amp;
AU_QUALIFIER float au_detail_bending_freq;
#   endif
#  endif
AU_QUALIFIER float au_wind_bending_amp;
AU_QUALIFIER float au_wind_bending_freq;
#  if BEND_CENTER_ONLY
GLSL_IN vec3 a_emitter_center;
#  endif
# endif

#if (WIND_BEND || DYNAMIC_GRASS || BILLBOARD) && !USE_INSTANCED_PARTCLS
AU_QUALIFIER vec3 au_center_pos;
# endif

# if VERTEX_ANIM
GLSL_IN vec3 a_position_next;
# endif

# if SKINNED
GLSL_IN vec4 a_influence;
# endif
#endif // DEBUG_SPHERE
//------------------------------------------------------------------------------

GLSL_OUT vec3 v_barycentric;

/*==============================================================================
                                   UNIFORMS
==============================================================================*/

#if STATIC_BATCH
// NOTE:  mat3(0.0, 0.0, 0.0, --- trans
//             1.0, --- scale
//             0.0, 0.0, 0.0, 1.0, --- quat
//             0.0);
const mat3 u_model_tsr = mat3(0.0, 0.0, 0.0,
                              1.0,
                              0.0, 0.0, 0.0, 1.0,
                              0.0);
#else
uniform mat3 u_model_tsr;
#endif


uniform mat3 u_view_tsr;
uniform mat4 u_proj_matrix;
#if !DEBUG_SPHERE
# if WIND_BEND
uniform vec3 u_wind;
uniform PRECISION float u_time;
#  if BILLBOARD && BILLBOARD_JITTERED
uniform float u_jitter_amp;
uniform float u_jitter_freq;
#  endif
# endif

# if DYNAMIC_GRASS || BILLBOARD
uniform vec3 u_camera_eye;
# endif

# if VERTEX_ANIM
uniform float u_va_frame_factor;
# endif

# if SKINNED
uniform vec4 u_quatsb[MAX_BONES];
uniform vec4 u_transb[MAX_BONES];
uniform vec4 u_arm_rel_trans;
uniform vec4 u_arm_rel_quat;
#  if FRAMES_BLENDING
uniform vec4 u_quatsa[MAX_BONES];
uniform vec4 u_transa[MAX_BONES];
// near 0 if before, near 1 if after
uniform float u_frame_factor;
#  endif
# endif

# if DYNAMIC_GRASS
uniform PRECISION sampler2D u_grass_map_depth;
uniform sampler2D u_grass_map_color;
uniform vec4 u_camera_quat;
uniform vec3 u_grass_map_dim;
uniform float u_grass_size;
uniform float u_scale_threshold;
# endif
#endif // DEBUG_SPHERE

/*==============================================================================
                                  INCLUDES
==============================================================================*/

#if !DEBUG_SPHERE
#include <skin.glslv>
#include <wind_bending.glslv>
#include <dynamic_grass.glslv>
#endif

/*==============================================================================
                                    MAIN
==============================================================================*/

void main() {

    if (a_polyindex == 0.0)
        v_barycentric = vec3(1.0, 0.0, 0.0);
    else if (a_polyindex == 1.0)
        v_barycentric = vec3(0.0, 1.0, 0.0);
    else if (a_polyindex == 2.0)
        v_barycentric = vec3(0.0, 0.0, 1.0);

#if DEBUG_VIEW_SPECIAL_SKYDOME
    gl_Position = vec4(a_position.xy, 0.9999999, 1.0);
#else
# if USE_INSTANCED_PARTCLS
    mat3 model_tsr = mat3(a_part_ts[0], a_part_ts[1], a_part_ts[2],
                        a_part_ts[3], a_part_r[0], a_part_r[1],
                        a_part_r[2], a_part_r[3], 1.0);
# if STATIC_BATCH
    mat4 model_mat = tsr_to_mat4(model_tsr);
# else
    mat4 model_mat = tsr_to_mat4(tsr_multiply(u_model_tsr, model_tsr));
# endif
# else
    mat4 model_mat = tsr_to_mat4(u_model_tsr);
# endif
    mat4 view_matrix = tsr_to_mat4(u_view_tsr);

    vec3 position = a_position;
    vec3 normal = a_normal;

# if DEBUG_SPHERE
    vertex world = to_world(position, vec3(0.0), vec3(0.0), vec3(0.0), vec3(0.0),
            vec3(0.0), model_mat);
# else
#  if VERTEX_ANIM
    position = mix(position, a_position_next, u_va_frame_factor);
#  endif

#  if SKINNED
    vec3 tangent = vec3(0.0);
    vec3 binormal = vec3(0.0);
    skin(position, tangent, binormal, normal);
#  endif

#  if (WIND_BEND || DYNAMIC_GRASS || BILLBOARD) && !USE_INSTANCED_PARTCLS
    vec3 center = au_center_pos;
#  elif DYNAMIC_GRASS && USE_INSTANCED_PARTCLS
    vec3 center = a_part_ts.xyz;
    position = (model_mat * vec4(position, 1.0)).xyz;
#  else
    vec3 center = vec3(0.0);
#  endif

#  if DYNAMIC_GRASS
    vertex world = grass_vertex(position, vec3(0.0), vec3(0.0), vec3(0.0), vec3(0.0),
            center, u_grass_map_depth, u_grass_map_color,
            u_grass_map_dim, u_grass_size, u_camera_eye, u_camera_quat,
            view_matrix);
#  else
#   if BILLBOARD
    vec3 wcen = (model_mat * vec4(center, 1.0)).xyz;

#    if BILLBOARD_PRES_GLOB_ORIENTATION && !STATIC_BATCH || USE_INSTANCED_PARTCLS
    mat4 model_matrix = billboard_matrix_global(u_camera_eye, wcen, 
            view_matrix, model_mat);
#    else
    mat4 model_matrix = billboard_matrix(u_camera_eye, wcen, view_matrix);
#    endif

#    if WIND_BEND && BILLBOARD_JITTERED
    vec3 vec_seed = (model_mat * vec4(center, 1.0)).xyz;
    model_matrix = model_matrix * bend_jitter_matrix(u_wind, u_time,
            u_jitter_amp, u_jitter_freq, vec_seed);
#    endif
    vertex world = to_world(position - center, center, vec3(0.0), vec3(0.0),
            vec3(0.0), vec3(0.0), model_matrix);
    world.center = wcen;
#   else
    vertex world = to_world(position, center, vec3(0.0), vec3(0.0), vec3(0.0),
            vec3(0.0), model_mat);
#   endif
#  endif

#  if WIND_BEND
    bend_vertex(world.position, world.center, normal);
#  endif
# endif // DEBUG_SPHERE

    gl_Position = u_proj_matrix * view_matrix * vec4(world.position, 1.0);
#endif // DEBUG_VIEW_SPECIAL_SKYDOME
}
