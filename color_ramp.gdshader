shader_type spatial;

render_mode vertex_lighting;

uniform sampler2D input_texture;

uniform vec3 red_color : source_color;
uniform vec3 black_color : source_color;

uniform vec2 uv_mult = vec2(1,1);


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = mix(black_color, red_color, texture(input_texture, UV * uv_mult).x);
}
