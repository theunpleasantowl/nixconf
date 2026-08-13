#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 c = texture(tex, v_texcoord);

    float bar = smoothstep(0.36, 0.5, abs(v_texcoord.y - 0.5));
    c.rgb = mix(c.rgb, vec3(0.0), bar);

    fragColor = c;
}
