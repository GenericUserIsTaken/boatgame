extends Node2D

@onready var shake_timer = $ShakeTimer
@onready var trash_sprite_pivot = $TrashSpritePivot
@onready var trash_sprite = $TrashSpritePivot/TrashSprite

### trash details
# the number of stages that are represented when losing health
const SCALE_STAGES = 3
# how much health does the trash have?
var health = 0
var max_health = 0
# how much money does it give on clearing?
var reward_value = 0
# where should it move to after spawn? (applicable when spawned offscreen)
const SPAWN_DRIFT_SPEED = 200
const SPAWN_DRIFT_LERP_RATE = 0.8
var spawn_target = Vector2.ZERO

### sprite shake details
const MAX_SHAKE_MAGNITUDE = 10
# controls the rate that shake offsets are applied
const SHAKE_INTERVAL = 0.05 # interval between setting new offests
var shake_cooldown = 0


func _ready():
	health = 10
	max_health = 10
	spawn_target = Vector2(500,200)
	print("trash ready")

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
		trash_sprite_pivot.position = Vector2(0,0)
		shake_cooldown = 0
		
	elif shake_cooldown <= 0:
		# make a random unit vector, scale it by random length and dampen over time
		var rand_angle = deg_to_rad(randf_range(0, 360))
		var rand_magnitude = randf() * MAX_SHAKE_MAGNITUDE
		var shake_time_dampening = shake_timer.get_time_left() / shake_timer.get_wait_time()
		trash_sprite_pivot.position = Vector2.from_angle(rand_angle) * rand_magnitude * shake_time_dampening
		shake_cooldown = fposmod(shake_cooldown, SHAKE_INTERVAL)
	
	# move to spawn target, used for spawning offscreen
	var lerped_position = GlobalManager.SmoothLerp(position, spawn_target, SPAWN_DRIFT_LERP_RATE, delta)
	position = position.move_toward(lerped_position, SPAWN_DRIFT_SPEED * delta)
	
	#TODO TEMP
	if Input.is_action_just_pressed("ui_up"):
		$Area2D2/tempcollider.set_deferred("disabled", false)
		print("disabled = false")
	

@warning_ignore("unused_parameter")
func _on_area_2d_area_entered(area: Area2D) -> void:
	$Area2D2/tempcollider.set_deferred("disabled", true) #TODO TEMP
	health -= 1#GlobalManager.Damage #TODO TEMP
	if health <= 0:
		# is destroyed
		#GlobalManager.AddMoney(reward_value) #TODO TEMP
		queue_free()
	else:
		# takes damage
		update_sprite()
		start_shake()
	
func start_shake():
	shake_timer.start()
	shake_cooldown = 0
	
func update_sprite():
	var health_percent = 0
	if max_health > 0:
		health_percent = clampf(health / float(max_health), 0, 1)
		
	var sprite_scale = ceil(SCALE_STAGES * health_percent) / SCALE_STAGES
	trash_sprite_pivot.scale = Vector2.ONE * sprite_scale
