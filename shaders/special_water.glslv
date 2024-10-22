#version GLSL_VERSION

/*==============================================================================
                            VARS FOR THE COMPILER
==============================================================================*/
#var DIR_MIN_SHR_FAC 0.0
#var DIR_FREQ 0.0
#var DIR_NOISE_SCALE 0.0
#var DIR_NOISE_FREQ 0.0
#var DIR_MIN_NOISE_FAC 0.0
#var DST_NOISE_SCALE_0 0.0
#var DST_NOISE_FREQ_0 0.0
#var DST_NOISE_SCALE_1 0.0
#var DST_NOISE_FREQ_1 0.0
#var DST_MIN_FAC 0.0
#var MAX_SHORE_DIST 0.0
#var PRECISION mediump
#var SHORE_MAP_CENTER_X 0.0
#var SHORE_MAP_SIZE_X 0.0
#var SHORE_MAP_CENTER_Y 0.0
#var SHORE_MAP_SIZE_Y 0.0
#var WAVES_HOR_FAC 0.0
#var WATER_LEVEL 0.0
#var WAVES_HEIGHT 0.0
#var WAVES_LENGTH 0.0

/*==============================================================================
                                  INCLUDES
==============================================================================*/

#include <std_enums.glsl>
#include <math.glslv>
#include <to_world.glslv>
#include <scale_texcoord.glslv>
#include <procedural.glslf>

/*==============================================================================
                                SHADER INTERFACE
==============================================================================*/
GLSL_IN vec3 a_position;

#if NUM_NORMALMAPS > 0 && !DYNAMIC
GLSL_IN vec3 a_normal;
GLSL_IN vec3 a_tangent;
#endif

#if !GENERATED_MESH && (NUM_NORMALMAPS > 0 || FOAM)
GLSL_IN vec2 a_texcoord;
#endif

#if DEBUG_WIREFRAME
GLSL_IN float a_polyindex;
#endif
//------------------------------------------------------------------------------

GLSL_OUT vec3 v_eye_dir;
GLSL_OUT vec3 v_pos_world;

#if (NUM_NORMALMAPS > 0 || FOAM) && !GENERATED_MESH
GLSL_OUT vec2 v_texcoord;
#endif

#if NUM_NORMALMAPS > 0
GLSL_OUT vec3 v_tangent;
GLSL_OUT vec3 v_binormal;
# endif

#if DYNAMIC || NUM_NORMALMAPS > 0
GLSL_OUT vec3 v_normal;
#endif

#if (NUM_NORMALMAPS > 0 || FOAM) && GENERATED_MESH && DYNAMIC
GLSL_OUT vec3 v_calm_pos_world;
#endif

#if SHORE_PARAMS
GLSL_OUT vec3 v_shore_params;
#endif

#if SHORE_SMOOTHING || REFLECTION_TYPE == REFL_PLANE || REFRACTIVE
GLSL_OUT vec3 v_tex_pos_clip;
#endif

#if SHORE_SMOOTHING || REFLECTION_TYPE == REFL_PLANE || REFRACTIVE || !DISABLE_FOG
GLSL_OUT float v_view_depth;
#endif

#if DEBUG_WIREFRAME
GLSL_OUT vec3 v_barycentric;
#endif

#if USE_TBN_SHADING
GLSL_OUT vec3 v_shade_tang;
#endif
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
uniform vec3 u_camera_eye;

#if DYNAMIC 
uniform PRECISION float u_time;
uniform vec3 u_wind;
#endif

#if SHORE_SMOOTHING || REFLECTION_TYPE == REFL_PLANE || REFRACTIVE || !DISABLE_FOG
uniform PRECISION float u_view_max_depth;
#endif

#if SHORE_PARAMS
uniform sampler2D u_shore_dist_map;
#endif

#if SHORE_PARAMS
vec3 extract_shore_params(in vec2 pos) {

    // shore coordinates from world position
    vec2 shore_coords = 0.5 +
            vec2( (pos.x - SHORE_MAP_CENTER_X) / SHORE_MAP_SIZE_X,
                 -(pos.y + SHORE_MAP_CENTER_Y) / SHORE_MAP_SIZE_Y);

    // unpack shore parameters from texture
    vec4 shore_params = GLSL_TEXTURE(u_shore_dist_map, shore_coords);

    const vec2 bit_shift = vec2( 1.0/255.0, 1.0);
    float shore_dist = dot(shore_params.ba, bit_shift);
    vec2 dir_to_shore = normalize(shore_params.rg * 2.0 - 1.0);

    return vec3(dir_to_shore, shore_dist);
}
#endif

#if DYNAMIC
#define M_PI 3.14159265359
#define SMALL_WAVES_FAC 0.3
void offset(inout vec3 pos, in float time, in vec3 shore_params) {

    // waves far from the shore
    float dist_waves =
                snoise(DST_NOISE_SCALE_0 * (pos.xz + DST_NOISE_FREQ_0 * time))
              * snoise(DST_NOISE_SCALE_1 * (pos.zx - DST_NOISE_FREQ_1 * time));

# if SHORE_PARAMS
    float shore_waves_length =  WAVES_LENGTH / MAX_SHORE_DIST / M_PI;
    float shore_dist = shore_params.b;
    float dist_fact = sqrt(shore_dist);

    // waves moving towards the shore
    float shore_dir_waves = max(shore_dist, DIR_MIN_SHR_FAC)
            * sin(dist_fact / shore_waves_length + DIR_FREQ * time);

    float dir_noise =
        max(snoise(DIR_NOISE_SCALE * (pos.xz + DIR_NOISE_FREQ * time)),
            DIR_MIN_NOISE_FAC);

    shore_dir_waves *= dir_noise;

    // mix two types of waves
    float waves_height = WAVES_HEIGHT * mix(shore_dir_waves, dist_waves,
                                            max(dist_fact, DST_MIN_FAC));

    // move high vertices towards the shore
    vec2 dir_to_shore = shore_params.rg;
    float wave_factor = WAVES_HOR_FAC * shore_dir_waves
                      * max(MAX_SHORE_DIST / 35.0 * (0.05 - shore_dist), 0.0);
    // horizontal offset for wave inclination
    vec2 hor_offset = wave_factor * dir_to_shore;
# else
    float waves_height = WAVES_HEIGHT * dist_waves;
# endif // SHORE_PARAMS

#if GENERATED_MESH
    // high resolution geometric noise waves
    vec2 coords21 = 2.0 * (pos.xz - 0.1  * time);
    vec2 coords22 = 1.3 * (pos.zx + 0.03 * time);
    float small_waves = cellular2x2(0.5 * (coords21 + coords22)).x - 0.5;

#  if SHORE_PARAMS
    pos.xz += hor_offset;
    small_waves *= shore_dist;
#  endif // SHORE_PARAMS
    waves_height += SMALL_WAVES_FAC * small_waves;
#endif // GENERATED_MESH

    pos.y += waves_height;
}
#endif // DYNAMIC

/*==============================================================================
                                    MAIN
==============================================================================*/

void main(void) {
    mat4 view_matrix = tsr_to_mat4(u_view_tsr);

    mat4 model_mat = tsr_to_mat4(u_model_tsr);
#if DEBUG_WIREFRAME
    if (a_polyindex == 0.0)
        v_barycentric = vec3(1.0, 0.0, 0.0);
    else if (a_polyindex == 1.0)
        v_barycentric = vec3(0.0, 1.0, 0.0);
    else if (a_polyindex == 2.0)
        v_barycentric = vec3(0.0, 0.0, 1.0);
#endif
    
#if GENERATED_MESH
    vec3 position = a_position;
    float casc_step = abs(position.y);
    vec2 step_xz = u_camera_eye.xz - mod(u_camera_eye.xz, casc_step);
# if WATER_EFFECTS
    position.y = WATER_LEVEL;
# else
    position.y = 0.0;
# endif
    position.xz += step_xz;// + vec2(15.0, -15.0);
    vec3 world_pos = position;
#else
# if NUM_NORMALMAPS > 0 || FOAM
    v_texcoord = a_texcoord;
# endif
    vertex world = to_world(a_position, vec3(0.0), vec3(0.0), vec3(0.0), vec3(0.0),
                            vec3(0.0), model_mat);
    vec3 world_pos = world.position;
#endif

#if SHORE_PARAMS
    v_shore_params = extract_shore_params(world_pos.xz);
#endif

#if DYNAMIC
    float wind_str = length(u_wind);
    float w_time = u_time;
    w_time *= wind_str;

# if GENERATED_MESH
    float vertex_delta = casc_step;
    // generate two neighbour vertices
    vec3 neighbour1 = world_pos + vec3(vertex_delta, 0.0, 0.0);
    vec3 neighbour2 = world_pos + vec3(0.0, 0.0, vertex_delta);
#  if NUM_NORMALMAPS > 0 || FOAM
    v_calm_pos_world = world_pos;
#  endif
# else
    vec3 neighbour1 = world_pos + vec3(0.05, 0.0, 0.0);
    vec3 neighbour2 = world_pos + vec3(0.0, 0.0, 0.05);
# endif // GENERATED_MESH
# if SHORE_PARAMS
    vec3 shore_params_n1 = extract_shore_params(neighbour1.xz);
    vec3 shore_params_n2 = extract_shore_params(neighbour2.xz);
    offset(neighbour1,     w_time, shore_params_n1);
    offset(neighbour2,     w_time, shore_params_n2);
    offset(world_pos, w_time, v_shore_params);
# else
    offset(neighbour1, w_time, vec3(0.0));
    offset(neighbour2, w_time, vec3(0.0));
    offset(world_pos, w_time, vec3(0.0));
# endif

# if GENERATED_MESH && WATER_EFFECTS
    // Last cascad needs to be flat and a bit lower than others
    if (a_position.y < 0.0) {
#  if WATER_EFFECTS
        world_pos.y = WATER_LEVEL - 1.0;
#  else
        world_pos.y = -1.0;
#  endif
        neighbour1.y = world_pos.y;
        neighbour2.y = world_pos.y;
    }
# endif

    // calculate all surface vectors based on 3 positions
    vec3 bitangent = normalize(neighbour1 - world_pos);
    vec3 tangent   = normalize(neighbour2 - world_pos);
    v_normal       = normalize(cross(tangent, bitangent));

    // NOTE: protect mesh from extreme normal values
    float up_dot_norm = dot(v_normal, vec3(0.0, 1.0, 0.0));
    float factor = clamp(0.8 - up_dot_norm, 0.0, 1.0);
    v_normal = mix(v_normal, vec3(0.0, 1.0, 0.0), factor);

#endif // DYNAMIC

#if NUM_NORMALMAPS > 0
# if !DYNAMIC
    vec3 tangent = a_tangent;
    v_normal = a_normal;
# endif
    v_tangent = tangent;
    v_binormal = cross(v_normal, v_tangent);
#endif // NUM_NORMALMAPS > 0

    v_pos_world = world_pos;
    v_eye_dir = u_camera_eye - world_pos;

    vec4 pos_view = view_matrix * vec4(world_pos, 1.0);
    vec4 pos_clip = u_proj_matrix * pos_view; 

#if SHORE_SMOOTHING || REFLECTION_TYPE == REFL_PLANE || REFRACTIVE
    float xc = pos_clip.x;
    float yc = pos_clip.y;
    float wc = pos_clip.w;

    v_tex_pos_clip.x = (xc + wc) / 2.0;
    v_tex_pos_clip.y = (yc + wc) / 2.0;
    v_tex_pos_clip.z = wc;
#endif

#if SHORE_SMOOTHING || REFLECTION_TYPE == REFL_PLANE || REFRACTIVE || !DISABLE_FOG
    v_view_depth = -pos_view.z / u_view_max_depth;
#endif

    gl_Position = pos_clip;
}
