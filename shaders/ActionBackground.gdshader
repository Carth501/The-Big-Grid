shader_type canvas_item;

uniform vec2 resolution = vec2(60.0, 40.0);
uniform vec3 line_color: source_color = vec3(0.2, 0.3, 0.5);
//uniform float zoom: hint_range(1.0, 50.0, 0.1) = 20.0;
uniform float min_brightness: hint_range(0.1, 4.0, 0.1) = 1.0;
uniform float brightness_range: hint_range(0.01, 1.0, 0.01) = 0.75;
uniform float cycle_speed: hint_range(0.01, 1.0, 0.01) = 0.5;
uniform float thickness: hint_range(0.01, 1.0, 0.01) = 0.5;

float draw_grid(vec2 uv) {
	vec2 grid_uv = (cos(uv * TAU) + thickness) / 2.0;
	return max(grid_uv.x, grid_uv.y);
}

float time_sin(vec2 uv, float x_co, float y_co) {
	return sin(TIME * cycle_speed + (x_co * uv.x) + (y_co * uv.y));
}

void fragment() {
	vec2 uv = UV * resolution / 16.0;
	vec3 color = draw_grid(uv) * line_color;
	float variation1 = time_sin(uv, 0.72, -0.04) + time_sin(uv, 0.07, 0.86) + time_sin(uv, -0.79, -0.97);
	float variation2 = time_sin(uv, -0.87, 0.48) + time_sin(uv, 0.52, 0.27) + time_sin(uv, -0.51, 0.23);
	float variation3 = time_sin(uv, 0.38, -0.42) + time_sin(uv, -0.69, -0.36) + time_sin(uv, 0.32, 0.17);
	float variations_sum = variation1 + variation2 + variation3;
	float wave = min_brightness + (clamp(0, variations_sum, 1) * brightness_range );
	COLOR = vec4(color * wave, 1.0);
}
