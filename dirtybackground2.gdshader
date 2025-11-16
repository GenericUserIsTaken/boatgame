shader_type canvas_item;

uniform sampler2D mask;

void fragment() {
	// Sample the mask texture
    //vec4 mask_color = texture(mask, UV);

    // Display the mask directly
    //COLOR = mask_color;
    vec4 base = texture(TEXTURE, UV);
    float erase = texture(mask, UV).r;
    COLOR = vec4(base.rgb, base.a * 0.5f * erase);
}