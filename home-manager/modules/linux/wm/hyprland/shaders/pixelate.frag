#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
uniform vec2 screen_size;
out vec4 fragColor;

const float PIXEL_SIZE = 8.0;

void main() {
  vec2 block = PIXEL_SIZE / screen_size;
  vec2 tc = (floor(v_texcoord / block) + 0.5) * block;

  fragColor = texture(tex, tc);
}
