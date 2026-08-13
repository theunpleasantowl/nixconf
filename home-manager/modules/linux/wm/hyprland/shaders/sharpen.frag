#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
uniform vec2 screen_size;
out vec4 fragColor;

void main() {
    vec2 texel = 1.0 / screen_size;

    vec4 c = texture(tex, v_texcoord) * 5.0;
    c -= texture(tex, v_texcoord + vec2( texel.x,  0.0));
    c -= texture(tex, v_texcoord + vec2(-texel.x,  0.0));
    c -= texture(tex, v_texcoord + vec2( 0.0,  texel.y));
    c -= texture(tex, v_texcoord + vec2( 0.0, -texel.y));

    fragColor = clamp(c, 0.0, 1.0);
}
