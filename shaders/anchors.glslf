#version GLSL_VERSION

#include <precision_statement.glslf>

/*==============================================================================
                                SHADER INTERFACE
==============================================================================*/

//------------------------------------------------------------------------------

GLSL_OUT vec4 GLSL_OUT_FRAG_COLOR;

/*==============================================================================
                                    MAIN
==============================================================================*/

void main(void) {
    GLSL_OUT_FRAG_COLOR = vec4(1.0);
}

