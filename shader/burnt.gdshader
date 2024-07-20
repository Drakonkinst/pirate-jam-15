shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
	// Called for every pixel the material is visible on.
    vec4 original = texture(TEXTURE, UV);
    vec4 color = original * texture(mask_texture, UV);
    color.a = original.a;
    COLOR = color;
}
