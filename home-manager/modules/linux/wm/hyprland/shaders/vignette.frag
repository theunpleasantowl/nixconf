#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
  vec4 c = texture(tex, v_texcoord);

  vec2 d = abs(v_texcoord - 0.5) * 1.5;
  float dist = dot(d, d);
  float vig = 1.0 - smoothstep(0.35, 1.0, dist) * 0.55;

  c.rgb *= mix(0.45, 1.0, vig);

  fragColor = c;
}
