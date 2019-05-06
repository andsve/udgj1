varying mediump vec2 var_texcoord0;

uniform highp sampler2D stripes;
uniform highp sampler2D snakes;
uniform highp vec4 screen;

vec2 edge(vec2 uv)
{

    vec2 up     = uv + vec2(      0.0    , screen.w    );
    vec2 up2    = uv + vec2(      0.0    , screen.w*2.0);
    vec2 down   = uv + vec2(      0.0    ,-screen.w    );
    vec2 down2  = uv + vec2(      0.0    ,-screen.w*2.0);
    vec2 left   = uv + vec2(-screen.z    ,      0.0    );
    vec2 left2  = uv + vec2(-screen.z*2.0,      0.0    );
    vec2 right  = uv + vec2( screen.z    ,      0.0    );
    vec2 right2 = uv + vec2( screen.z*2.0,      0.0    );
    vec2 mid    = uv;

    vec2 u_l    = uv + vec2(-screen.z    , screen.w    );
    vec2 u_r    = uv + vec2( screen.z    , screen.w    );
    vec2 d_l    = uv + vec2(-screen.z    ,-screen.w    );
    vec2 d_r    = uv + vec2( screen.z    ,-screen.w    );
    

    vec4 up_t    = texture2D(snakes, up);
    vec4 down_t  = texture2D(snakes, down);
    vec4 left_t  = texture2D(snakes, left);
    vec4 right_t = texture2D(snakes, right);
    vec4 mid_t   = texture2D(snakes, mid);

    vec4 up2_t    = texture2D(snakes, up2);
    vec4 down2_t  = texture2D(snakes, down2);
    vec4 left2_t  = texture2D(snakes, left2);
    vec4 right2_t = texture2D(snakes, right2);

    vec4 u_l_t = texture2D(snakes, u_l);
    vec4 u_r_t = texture2D(snakes, u_r);
    vec4 d_l_t = texture2D(snakes, d_l);
    vec4 d_r_t = texture2D(snakes, d_r);

    // calc normal
    float up_left = up_t.a + left_t.a + up2_t.a + left2_t.a + u_l_t.a + d_l_t.a;
    float down_right = down_t.a + right_t.a + down2_t.a + right2_t.a + d_r_t.a + u_r_t.a;

    return vec2(up_t.a + down_t.a + left_t.a + right_t.a + mid_t.a, up_left - down_right);
}

float blendSubtract(float base, float blend) {
    return max(base+blend-1.0,0.0);
}

vec3 blendSubtract(vec3 base, vec3 blend) {
    return max(base+blend-vec3(1.0),vec3(0.0));
}

vec3 blendSubtract(vec3 base, vec3 blend, float opacity) {
    return (blendSubtract(base, blend) * opacity + base * (1.0 - opacity));
}

vec3 czm_saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

void main()
{
    vec2 half_pix_offset = vec2(0.0); //vec2(screen.z / 2.0, screen.w / 2.0);
    vec2 e = edge(var_texcoord0.xy + half_pix_offset);
    
    if (e.x < 4.0) {
        discard;
        return;
    }

    

    /*
    vec3 c = vec3(142.0/255.0, 22.0/255.0, 102.0/255.0);
    if (e.y < 0.0) {
        c = vec3(242.0/255.0, 92.0/255.0, 145.0/255.0);
    } else if (e.y > 0.0) {
        c = vec3(93.0/255.0, 28.0/255.0, 89.0/255.0);
    }
    */
    vec3 c = texture2D(snakes, var_texcoord0.xy).rgb;
    if (e.y < 0.0) {
        //c = czm_saturation(c, 1.0)+0.1;
        c *= 1.6;
    } else if (e.y > 0.0) {
        c *= 0.6;
    }

    vec2 stripes_uv = var_texcoord0.xy * vec2(screen.x / 16.0, screen.y / 16.0);
    vec4 stripes_t = texture2D(stripes, stripes_uv);
    gl_FragColor = vec4(blendSubtract(c, stripes_t.rgb, 0.1), 1.0);
    //gl_FragColor = vec4(c, stripes_t.a);
    
    //gl_FragColor = vec4(e/5.0, 0.0, 0.0, 1.0);
    //vec4 tmp = texture2D(snakes, var_texcoord0.xy);
    //gl_FragColor = vec4(tmp.a, 0.0, 0.0, 1.0);
}
