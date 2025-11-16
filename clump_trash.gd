extends Node2D

@onready var shake_timer = $ShakeTimer
@onready var trash_sprite = $TrashSprite

### trash details
# the number of stages that are represented when losing health
const SCALE_STAGES = 3
# how much health does the trash have?
var health
var max_health
# how much money does it give on clearing?
var reward_value
# where should it move to after spawn? (applicable when spawned offscreen)
const SPAWN_DRIFT_SPEED = 20
var spawn_target

### sprite shake details
const MAX_SHAKE_MAGNITUDE = 20
# controls the rate that shake offsets are applied
const SHAKE_INTERVAL = 0.1 # 1/10 -> 10 times per second
var shake_cooldown = 0


func setup(_sprite, _health, _reward_value, _spawn_target):
	trash_sprite.set_texture(_sprite)
	self.health = _health
	self.max_health = _health
	self.reward_value = _reward_value
	self.spawn_target = _spawn_target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shake_cooldown -= delta
	
	if shake_timer.is_stopped():
		trash_sprite.position = Vector2(0,0)
		shake_cooldown = 0
		
	elif shake_cooldown <= 0:
		# make a random unit vector, scale it by random length and dampen over time
		var rand_angle = deg_to_rad(randf_range(0, 360))
		var rand_magnitude = randf() * MAX_SHAKE_MAGNITUDE
		var shake_time_dampening = shake_timer.get_time_left() / shake_timer.get_wait_time()
		trash_sprite.positon = Vector2.from_angle(rand_angle) * rand_magnitude * shake_time_dampening
		shake_cooldown = fposmod(shake_cooldown, SHAKE_INTERVAL)
	
	var lerped_position = GlobalManager.SmoothLerp(global_position, spawn_target, 0.5, delta)
	global_position = global_position.move_toward(lerped_position, SPAWN_DRIFT_SPEED * delta)
	
	#if Input.action_press("ui_up"):
		#$Area2D2/tempcollider.set_deferred(true)
		

@warning_ignore("unused_parameter")
func _on_area_2d_area_entered(area: Area2D) -> void:
	health -= GlobalManager.Damage
	if health <= 0:
		# is destroyed
		GlobalManager.AddMoney(reward_value)
		queue_free()
	else:
		# takes damage
		update_sprite()
		start_shake()
	
func start_shake():
	shake_timer.start()
	shake_cooldown = 0
	
func update_sprite():
	var health_percent = clampf(health / max_health, 0, 1)
	trash_sprite.transform.scale = ceil(SCALE_STAGES * health_percent) / SCALE_STAGES
