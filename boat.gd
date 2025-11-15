extends PhysicsBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var accelaration 
	pass
	
	


func _process(delta:):
	var speed
	var friction = 
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 0:
		speed = direction.normalized() * speed
	else:
		speed = direction.normalized() - friction
