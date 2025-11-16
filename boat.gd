extends RigidBody2D
@onready var Pivot = $Pivot
@onready var ScoopCollider = $Pivot/Area2D/ScoopCollider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	


func _physics_process(delta:):
	var vectorplayertomouse = get_global_mouse_position() - global_position
	var mouseangle = atan2(vectorplayertomouse.x, -vectorplayertomouse.y)
	mouseangle = rad_to_deg(mouseangle)
	print (mouseangle)
	Pivot.rotation_degrees = mouseangle
	ScoopCollider.position.y = - (ScoopCollider.shape.get_height() / 2)
	

	
	gravity_scale = 0
	var accelaration = 20
	var speed = accelaration * 2
	var MaxSpeed = 200
	var friction = 4 * speed
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.length() > 0:
		#current speed, float:   self.linear_velocity.length()
		#current direcition, vector2:   self.linear_velocity.normalized()
		self.apply_force( direction.normalized() * speed)
	elif (self.linear_velocity.length() > friction):
		pass
		#self.apply_force( direction.normalized() * friction)
		#self.apply_force( (-self.linear_velocity.normalized()) * friction)
	elif (self.linear_velocity.length() < friction):
		self.apply_force(-self.linear_velocity)
		#get our current velocity
		#get the opposite direction of our current movement
		#if friction force is greater than current velocity speed apply current velocity speed in opposie direction
		#else apply a friction force in the opposite direction of current velocity 
	#self.apply_central_force(speed)
