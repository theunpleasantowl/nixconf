#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const mat3 SHIFT = mat3(
    0.0, 0.0, 1.0,
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0);

void main() {
    vec4 c = texture(tex, v_texcoord);

    float gray = dot(c.rgb, vec3(0.2126, 0.7152, 0.0722));
    vec3 shifted = c.rgb * SHIFT;
    float sGray = dot(shifted, vec3(0.2126, 0.7152, 0.0722));
    shifted *= gray / max(sGray, 0.0001);

    fragColor = vec4(shifted, c.a);
}
