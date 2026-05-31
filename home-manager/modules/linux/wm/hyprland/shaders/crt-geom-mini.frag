#version 300 es
// Hyprland screen-shader adaptation of libretro's crt-geom-mini.glsl.
// Original: https://github.com/libretro/glsl-shaders/blob/master/crt/shaders/crt-geom-mini.glsl
// Copyright (c) 2024 DariusG. MIT licensed.

precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float PI = 3.14159265359;
const float TAU = 6.28318530718;
const float CURVATURE = 1.0;
const float SCANLINE_WEIGHT = 0.22;
const float MASK_STRENGTH = 0.08;
const float BRIGHTNESS_COMPENSATION = 1.12;
const vec2 CURVATURE_DISTORTION = vec2(0.12, 0.25);
const vec2 BARREL_SCALE = vec2(0.97, 0.945);

vec2 warp(vec2 coord) {
  coord -= vec2(0.5);
  float rsq = dot(coord, coord);
  coord += coord * (CURVATURE_DISTORTION * rsq * CURVATURE);
  coord *= BARREL_SCALE;

  if (abs(coord.x) >= 0.5 || abs(coord.y) >= 0.5) {
    return vec2(-1.0);
  }

  return coord + vec2(0.5);
}

void main() {
  vec2 tc = warp(v_texcoord);

  if (tc.x < 0.0) {
    fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    return;
  }

  vec4 source = texture(tex, tc);
  vec3 color = source.rgb;

  float luminance = dot(color, vec3(0.29, 0.6, 0.11));
  float adaptiveScanline = mix(SCANLINE_WEIGHT, SCANLINE_WEIGHT * 0.6, luminance);
  float scanline = adaptiveScanline * sin((tc.y * 1080.0 + 0.15) * TAU) + 1.0 - adaptiveScanline;
  float mask = MASK_STRENGTH * sin(gl_FragCoord.x * PI) + 1.0 - MASK_STRENGTH;

  color *= scanline * mask * BRIGHTNESS_COMPENSATION;
  color = clamp(color, vec3(0.0), vec3(1.0));

  fragColor = vec4(color, source.a);
}
