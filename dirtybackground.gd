extends TextureRect

const width = 1920
const height = 1080
const screen_size = Vector2(width,height)
var mask_image
var mask_texture 
@onready var boat = $"../Boat"

@warning_ignore("shadowed_variable_base_class")
func _on_visibilty_request(visible : bool):
	self.visible = visible

func _ready():
	makenewmask()
	GlobalManager.connect("ChangeBackgroundVisibility", _on_visibilty_request)
	GlobalManager.connect("ResetCanvas", makenewmask)

func makenewmask():
	#mask_image = Image.create(width, height, false, Image.FORMAT_RF) 
	mask_image = Image.create_empty(width, height, false, Image.FORMAT_RGBA8)
	mask_image.fill(Color(1,1,1,1)) # start fully visible (white)
	mask_texture = ImageTexture.create_from_image(mask_image)
	#self.material.set_shader_param("mask", mask_texture)
	var mat := self.material as ShaderMaterial
	mat.set_shader_parameter("mask", mask_texture)

func world_to_screen(world_pos: Vector2) -> Vector2:
	# Get the viewport size (e.g. 1920x1080)
	#var screen_size = get_viewport().get_visible_rect().size
	var screen_pos = Vector2(world_pos.x + screen_size.x / 2,world_pos.y+ (screen_size.x / 2))
	screen_pos += Vector2(0,-400)
	# Shift world origin (0,0) to the center of the screen
	#var screen_pos = world_pos + screen_size / 2
	
	return screen_pos


func _process(delta: float) -> void:
	if boat:
		erase_at_world_position(world_to_screen(boat.position))
		print(boat.position)

#func _input(event):
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		# Get the mouse position in world coordinates
#		var mouse_pos = get_local_mouse_position()
#		# Call your erase function at that position
#		erase_at_world_position(mouse_pos)


func erase_at_world_position(local_pos: Vector2):
	# local_pos is relative to the TextureRect
	var px = int(local_pos.x / get_size().x * mask_image.get_width())
	var py = int(local_pos.y / get_size().y * mask_image.get_height())

	for x in range(-50, 51):
		for y in range(-5, 50):
			var cx = px + x
			var cy = py + y
			if cx >= 0 and cy >= 0 and cx < mask_image.get_width() and cy < mask_image.get_height():
				mask_image.set_pixel(cx, cy, Color(0,0,0,1)) # erase
	mask_texture.update(mask_image)
