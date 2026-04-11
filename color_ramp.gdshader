shader_type spatial;

render_mode vertex_lighting, cull_disabled;

uniform sampler2D input_texture;

uniform vec3 red_color : source_color;
uniform vec3 black_color : source_color;

uniform vec2 uv_mult = vec2(1,1);

group_uniforms Squiggle;
/**
 * Noise texture scale
 * By default, the noise texture's size in world coordinates is set by its resolution
*/
uniform vec2 scale = vec2(1.0);
uniform float strength = 10.0;
/**
 * Number of squiggle frames per second
*/
uniform float fps = 6.0;
uniform sampler2D noise : filter_linear, repeat_enable;
group_uniforms;

varying vec4 modulate;
varying vec2 noise_uv;

void vertex() {
	// Called for every vertex the material is visible on.
	modulate = COLOR;
	
	// Use world coordinates for scale-independent squiggles, offset by position to keep pattern attached to object
	noise_uv = (vec2(textureSize(noise, 0)) * scale);
}
// Use irrational constants for unique squiggles every frame
#define offset_multiplier vec2(PI, E)

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 noise_offset = vec2(floor(TIME * fps)) * offset_multiplier;
	float noise_sample = texture(noise, noise_uv + noise_offset).r * 4.0 * PI;
	vec2 direction = vec2(cos(noise_sample), sin(noise_sample));
	vec2 squiggle_uv = UV + direction * strength * 0.005;
	
	ALBEDO = mix(black_color, red_color, texture(input_texture, squiggle_uv * uv_mult).x);
	ALPHA = texture(input_texture, squiggle_uv * uv_mult).a;
	ALPHA_SCISSOR_THRESHOLD = 0.1;
	ALPHA_ANTIALIASING_EDGE = 0.8;
	//Use this if squiggle sucks
	//ALBEDO = mix(black_color, red_color, texture(input_texture, UV * uv_mult).x);
	
}
