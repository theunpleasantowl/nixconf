#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 c = texture(tex, v_texcoord);

    float gray = dot(c.rgb, vec3(0.2126, 0.7152, 0.0722));
    c.rgb = mix(vec3(gray), c.rgb, 1.25);
    c.rgb = (c.rgb - 0.5) * 1.08 + 0.5;

    fragColor = vec4(clamp(c.rgb, 0.0, 1.0), c.a);
}
