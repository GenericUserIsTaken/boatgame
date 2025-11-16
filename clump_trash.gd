extends Node2D

@onready var shake_timer = $ShakeTimer
@onready var trash_sprite = $TrashSprite

### trash details
# how much health does the trash have?
var durability
# how much money does it give on clearing?
var reward_value
# where should it move to after spawn? (applicable when spawned offscreen)
var spawn_target

### sprite shake details
const MAX_SHAKE_MAGNITUDE = 20
# controls the rate that shake offsets are applied
const SHAKE_INTERVAL = 0.1 # 1/10 -> 10 times per second
var shake_cooldown = 0


func setup(set_sprite, set_durability, set_reward_value):
	trash_sprite.set_texture(set_sprite)
	durability = set_durability
	reward_value = set_reward_value
	

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

func _on_area_2d_area_entered(area: Area2D) -> void:
	
	start_shake()
	
func start_shake():
	shake_timer.start()
	shake_cooldown = 0
