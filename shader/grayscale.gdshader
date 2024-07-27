shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec3 tint;
uniform float desaturation = 1.0;  // 1.0 for full grayscale, 0.5 for darken, 0.0 for original color

void fragment() {
    // Get the current color
    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
    // Not sure if this is the right way to do this but it works to only affect the actual texture
    if(COLOR.a < 0.0) {
        // Average the color
        float grayscale = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
        COLOR.rgb = vec3(mix(COLOR.r, grayscale, desaturation), mix(COLOR.g, grayscale, desaturation), mix(COLOR.b, grayscale, desaturation));
        // Add our tint to the color by averaging them together
        COLOR.rgb = COLOR.rgb * 0.5 + tint.rgb * 0.5;
    }
}