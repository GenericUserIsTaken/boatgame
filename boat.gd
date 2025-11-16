extends RigidBody2D
@onready var Pivot = $Pivot
@onready var ScoopCollider = $Pivot/Area2D/ScoopCollider
@onready var boat = $"."
var timer = Timer.new()
const startheight = 250.0 * 0.5
const startRad = 80.0 / 0.7 * 0.5


# Called when the node enters the scene tree for the fi-t time.
func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	var startTimer = 0.5
	timer.wait_time = startTimer
	
	#$Pivot/NetVizualizer.shape.height = actheight
	#$Pivot/NetVizualizer.shape.radius = actRad
	
func _physics_process(_delta):
	
	var actheight = startheight * GlobalManager.Size
	var actRad = startRad * GlobalManager.Size * 0.7
	ScoopCollider.shape.height = actheight
	ScoopCollider.shape.radius = actRad
	print("/boat ",ScoopCollider.shape.height," ",ScoopCollider.shape.radius)
	
	#flips sprite
	if (self.linear_velocity.x > 0):
		$Sprite2D.flip_h = false
		#print(self.linear_velocity.x)
	elif (self.linear_velocity.x < 0):
		#print(self.linear_velocity.x)
		$Sprite2D.flip_h = true
	
	var vectorplayertomouse = get_global_mouse_position() - global_position
	var mouseangle = atan2(vectorplayertomouse.x, -vectorplayertomouse.y)
	mouseangle = rad_to_deg(mouseangle)
	Pivot.rotation_degrees = mouseangle
	ScoopCollider.position.y = - (ScoopCollider.shape.get_height() / 2)
	
	#print (timer.time_left)
	
	if (Input.is_action_pressed("LeftClick") && timer.is_stopped()) :
		timer.start()
		#print("ran")
		#print("Again")
		ScoopCollider.set_deferred("disabled", false)
		#print ("ScoopAppeared")
		#print ("timer")
		
	else :
		ScoopCollider.set_deferred("disabled", true)
		
	if (Input.is_action_pressed("LeftClick")) :
		$Pivot/NetVizualizer.visible = true
	else:
		$Pivot/NetVizualizer.visible = false
	
	gravity_scale = 0
	var accelaration = 11
	var speed = accelaration * 2
	var MaxSpeed = 200
	var friction = 4 * speed
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#GlobalManager.Size
	#GlobalManager.Speed
	#GlobalManager.Damage
	if direction.length() > 0:
		#current speed, float:   self.linear_velocity.length()
		#current direcition, vector2:   self.linear_velocity.normalized()
		self.apply_force( direction.normalized() * speed * GlobalManager.Speed)
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
