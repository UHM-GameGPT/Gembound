shader_type canvas_item;

void fragment() {
	vec4 text_color = texture(TEXTURE, UV);

	float gray = text_color.r * 0.299 + text_color.g * 0.587 + text_color.b * 0.114;

	COLOR = vec4(vec3(gray), text_color.a);
}
