extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	


func _process(delta:):
	gravity_scale = 0
	var accelaration = 2
	var speed = accelaration * 2
	var MaxSpeed = 200
	var friction = 2 * speed
	var direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_pressed("ui_right"):
		if direction.length() > 0:
			speed = direction.normalized() * speed
		else:
			speed = direction.normalized() - friction
	if Input.is_action_pressed("ui_left"):
		if direction.length() > 0:
			speed = direction.normalized() * speed
		else:
			speed = direction.normalized() - friction
	if Input.is_action_pressed("ui_up"):
		if direction.length() > 0:
			speed = direction.normalized() * speed
		else:
			speed = direction.normalized() - friction
	if Input.is_action_pressed("ui_down"):
		if direction.length() > 0:
			speed = direction.normalized() * speed
		else:
			speed = direction.normalized() - friction
