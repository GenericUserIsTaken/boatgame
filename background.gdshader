shader_type canvas_item;

uniform float scale = 20.0; //desired scale
void vertex() {
	//UV *= scale;
    //the 0.5 vector centers the transformation in the center of the texture, while multipling by a positive number scales it out
	//the texture mode is set to repeating so it repeats the texture
    UV = (UV - vec2(0.5)) * scale + vec2(0.5);

	//if we wanted scroll
	//UV.x += TIME * .1;
	//UV.y += TIME * .1;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
