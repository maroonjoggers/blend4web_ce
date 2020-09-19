#version GLSL_VERSION

/*==============================================================================
                            VARS FOR THE COMPILER
==============================================================================*/
#var PRECISION lowp

/*============================================================================*/

#include <math.glslv>
#include <to_world.glslv>

uniform mat3 u_view_tsr;
uniform mat4 u_proj_matrix;
uniform PRECISION float u_halo_size;

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

/*==============================================================================
                                SHADER INTERFACE
==============================================================================*/
GLSL_IN vec3 a_position;
GLSL_IN vec2 a_halo_bb_vertex;
GLSL_IN float a_random_vals;
//------------------------------------------------------------------------------

GLSL_OUT vec2 v_texcoord;
GLSL_OUT float v_vertex_random;

#if WATER_EFFECTS && !DISABLE_FOG
GLSL_OUT vec4 v_position_world;
#endif

/*==============================================================================
                                    MAIN
==============================================================================*/

void main(void) {
    mat4 view_matrix = tsr_to_mat4(u_view_tsr);

    mat4 model_matrix = tsr_to_mat4(u_model_tsr);

    vec3 position = (model_matrix * vec4(a_position, 1.0)).xyz;

    v_texcoord = a_halo_bb_vertex * 2.0;

    //random value for every halo (0..1)
    v_vertex_random = a_random_vals;

#if SKY_STARS
    mat4 bb_matrix = billboard_spherical(position, view_matrix);
    mat4 view_copy = view_matrix;
    view_copy[3][0] = 0.0;
    view_copy[3][1] = 0.0;
    view_copy[3][2] = 0.0;
#else
    mat4 bb_matrix = billboard_spherical(position, view_matrix);
#endif

    vec4 pos_local = vec4(a_halo_bb_vertex * 2.0 * u_halo_size, 0.0, 1.0);
    vec4 pos_world = bb_matrix * pos_local;

#if SKY_STARS
    vec4 pos_clip = u_proj_matrix * view_copy * pos_world;
    pos_clip.z = 0.99999 * pos_clip.w;
# if WATER_EFFECTS && !DISABLE_FOG
    v_position_world = pos_world;
# endif
#else
    vec4 pos_clip = u_proj_matrix * view_matrix * pos_world;
#endif

    gl_Position = pos_clip;
}
