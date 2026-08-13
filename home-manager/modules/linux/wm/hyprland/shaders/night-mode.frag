#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
  vec4 c = texture(tex, v_texcoord);

  c.r *= 1.04;
  c.g *= 0.97;
  c.b *= 0.80;

  float gray = dot(c.rgb, vec3(0.2126, 0.7152, 0.0722));
  c.rgb = mix(c.rgb, vec3(gray), 0.12);

  fragColor = c;
}
