#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec2 tc = v_texcoord - 0.5;
    tc *= 1.0 + dot(tc, tc) * 0.12;
    tc += 0.5;

    if (tc.x < 0.0 || tc.x > 1.0 || tc.y < 0.0 || tc.y > 1.0) {
        fragColor = vec4(0.0);
        return;
    }

    vec4 c = texture(tex, tc);

    float scan = 0.5 + 0.5 * sin(gl_FragCoord.y * 2.8);
    c.rgb *= mix(0.72, 1.0, scan);

    float phase = fract(gl_FragCoord.x / 3.0);
    vec3 mask = vec3(
        step(0.0, 0.333 - phase),
        step(0.333, phase) * step(0.0, 0.667 - phase),
        step(0.667, phase));
    c.rgb *= 0.75 + 0.35 * mask;

    fragColor = c;
}
