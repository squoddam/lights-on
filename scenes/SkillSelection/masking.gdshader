shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec2 position;
uniform float radius;

void fragment() {
	COLOR = textureLod(TEXTURE, UV, 0.0);
	COLOR.a = distance(UV, position) > radius ? 0. : 1.;

	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

	//if (c.a > 0.0001) {
		//c.rgb /= c.a;
	//}

	COLOR *= c;
}
