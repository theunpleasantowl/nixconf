#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

void main() {
    vec4 c = texture(tex, v_texcoord);
    float n = hash(gl_FragCoord.xy);
    c.rgb += (n - 0.5) * 0.07;
    fragColor = c;
}
