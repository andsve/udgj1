varying mediump vec2 var_texcoord0;

uniform highp sampler2D tex;

void main()
{
    gl_FragColor = texture2D(tex, var_texcoord0.xy);
}
