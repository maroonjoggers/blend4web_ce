#export lin_to_srgb srgb_to_lin
#export premultiply_alpha
#export luma

#define GAMMA 1
#define PREMULTIPLY_ALPHA 1

void srgb_to_lin(inout vec3 color)
{
/*
    if (all(lessThanEqual(color, vec3(0.04045))))
        color = color / 12.92;
    else
        color = pow(((color + vec3(0.055))/1.055), vec3(2.4));
*/
    #if GAMMA
        color = max(vec3(0.0), color);
        color = pow(color, vec3(2.2));
    #endif
}

void srgb_to_lin(inout float color)
{
    #if GAMMA
        color = pow(max(0.0, color), 2.2);
    #endif
}

void lin_to_srgb(inout vec3 color)
{
    #if GAMMA
        color = max(vec3(0.0), color);
        color = pow(color, vec3(1.0/2.2));
    #endif
}

void premultiply_alpha(inout vec3 color, in float alpha)
{
#if PREMULTIPLY_ALPHA
    color = color * alpha;
#endif
}

float luma(vec4 color) {
    vec3 luma_coeff = vec3(0.299, 0.587, 0.114);
    float l = dot(color.rgb, luma_coeff);
    return l;
}
