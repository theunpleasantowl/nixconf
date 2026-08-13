#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 c = texture(tex, v_texcoord);

    float lum = dot(c.rgb, vec3(0.2126, 0.7152, 0.0722));
    c.rgb += pow(lum, 12.0) * 1.2;

    fragColor = vec4(clamp(c.rgb, 0.0, 1.0), c.a);
}
