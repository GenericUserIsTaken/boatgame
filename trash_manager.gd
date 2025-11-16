extends Node2D

@onready var ClumpTrashFolder = $ClumpTrashFolder
var clump_trash_node = preload("res://clump_trash.tscn")

const INITIAL_SPAWN_PERCENT = 0.4
const SPAWN_TIME_RANGE = 0.8
const SPAWN_ZONE = Vector2(1920, 1080)
const SPAWN_BORDER_MARGIN = 50
#const SPAWN_PROXY_MARGIN = 30 #TODO spawn spacing


# which objects exist, and how many have been cleared so far
var trash_list = []
var trash_cleared = 0
# total amount that can be cleared over entire round_time
var trash_max = 0
# each entry is the time to spawn at,
# and the number of entries is the number left to spawn
var spawn_queue_times = []
# how much time for the round
var round_time = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalManager.connect("SpawnTrash", _on_spawn_trash)
	GlobalManager.connect("ResetLevel", _on_reset_level)

@warning_ignore("unused_parameter")
func _on_spawn_trash(TrashAmount : int, RoundTime : float, SurfaceTrashVisible : bool):
	self.trash_max = TrashAmount
	self.round_time = RoundTime
	#TODO surface trash visible is current unused
	
	var need_to_spawn = trash_max
	
	# calc initial wave of trash for immediate startup
	var init_spawn = need_to_spawn * INITIAL_SPAWN_PERCENT
	need_to_spawn -= init_spawn
	for i in range(init_spawn):
		spawn_rand_trash(false)
	
	# schedule spawns for the rest of the level
	while need_to_spawn > 0:
		spawn_queue_times.append(randf())
		need_to_spawn -= 1
	spawn_queue_times.sort()
	for i in range(len(spawn_queue_times)):
		spawn_queue_times[i] *= round_time * SPAWN_TIME_RANGE
	

func _on_reset_level():
	print("/tm cleared!")
	for trash_node in trash_list:
		trash_node.queue_free()
		
	trash_list.clear()
	spawn_queue_times.clear()
	
	trash_cleared = 0
	trash_max = 0
	round_time = 0
	
	calc_trash_percent()

func notify_removal(elem):
	print("/tm attempting to remove 1 elem, before size: ", trash_list.size())
	trash_list.erase(elem)
	trash_cleared += 1
	print("/tm after size: ", trash_list.size())
	calc_trash_percent()

func calc_trash_percent():
	var trash_percent = 0.0 if trash_max <= 0 else trash_cleared / float(trash_max)
	GlobalManager.UpdateTrashPercent.emit(trash_percent)
	

func spawn_rand_trash(drifts_in : bool):
	# demo: https://www.desmos.com/calculator/lmssvon8ha
	var spawn_target = Vector2(randf(), randf())
	spawn_target.x *= (SPAWN_ZONE.x - SPAWN_BORDER_MARGIN * 2)
	spawn_target.y *= (SPAWN_ZONE.y - SPAWN_BORDER_MARGIN * 2)
	spawn_target += SPAWN_BORDER_MARGIN * Vector2.ONE
	
	var spawn_pos = spawn_target
	if (drifts_in):
		spawn_pos -= SPAWN_ZONE / 2
		spawn_pos = spawn_pos.normalized() + Vector2(randf() - 0.5, randf() - 0.5) # random bs go
		spawn_pos = spawn_pos.normalized() * (SPAWN_ZONE.length() + SPAWN_BORDER_MARGIN * 2)
	
	var new_trash_node = clump_trash_node.instantiate()
	ClumpTrashFolder.add_child(new_trash_node)
	trash_list.append(new_trash_node)
	new_trash_node.global_position = spawn_pos
	
	# new_trash_node.setup(sprite, health, reward_value, spawn_target, trash_manager_ref)
	match randi_range(1, 1):
		1: new_trash_node.setup(null, randi_range(5,7), randi_range(1,3), spawn_target, self.get_script())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# check spawn queue for scheduled trash that should drift in
	if not spawn_queue_times.is_empty():
		var game_time_elapsed = GlobalManager.gametime.get_wait_time() - GlobalManager.gametime.get_time_left()
		# spawn trash for all timestamps passed
		while (not spawn_queue_times.is_empty() and game_time_elapsed >= spawn_queue_times[0]):
			spawn_queue_times.remove_at(0)
			spawn_rand_trash(true)
