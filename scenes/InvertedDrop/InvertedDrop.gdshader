shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

global uniform vec4 color1;
global uniform vec4 color2;

uniform vec2 position = vec2(0.);
uniform float radius = 0.;

void fragment() {
	vec4 tc = textureLod(screen_texture, SCREEN_UV, 0.);

	if (distance(UV, position) >= radius) {
		COLOR = tc == color1 ? color2 : color1;
	} else {
		COLOR = tc;
	}
}
