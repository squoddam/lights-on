shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 col : source_color = vec4(1.);
uniform vec2 position = vec2(.5);
uniform float radius = .5;

const vec4 WHITE = vec4(1., 1., 1., 1.);
const vec4 BLACK = vec4(0., 0., 0., 1.);

void fragment() {
	//COLOR = textureLod(screen_texture, SCREEN_UV, 0.) == WHITE ? BLACK : WHITE;
	
	vec4 tc = textureLod(screen_texture, SCREEN_UV, 0.);
	
	if (distance(UV, position) > radius) {
		//COLOR = tc == WHITE ? BLACK : WHITE;
		COLOR = col;
	} else {
		COLOR = tc;
	}
}
