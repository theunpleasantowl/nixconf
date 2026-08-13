#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec2 tc = v_texcoord - 0.5;
    tc *= 1.0 + dot(tc, tc) * 1.2;
    tc += 0.5;

    if (tc.x < 0.0 || tc.x > 1.0 || tc.y < 0.0 || tc.y > 1.0) {
        fragColor = vec4(0.0);
        return;
    }

    fragColor = texture(tex, tc);
}
