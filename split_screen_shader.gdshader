shader_type canvas_item;
render_mode unshaded;

uniform bool visible;
uniform sampler2D viewport1 : source_color;
uniform sampler2D viewport2 : source_color;

uniform vec2 line_0;
uniform vec2 line_1;

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 view1 = texture(viewport1, UV).rgb;
	vec3 view2 = texture(viewport2, UV).rgb;
	
	if (visible) {
		vec2 direction = line_1 - line_0;
		vec2 shifted = UV - line_0;
		
		if (cross(vec3(direction, 0.0), vec3(shifted, 0.0)).z > 0.0) {
			COLOR = vec4(view2, 1.0);
		}
		else {
			COLOR = vec4(view1, 1.0);
		}
	}
	else {
		COLOR = vec4(view1, 1.0);
	}

}
