extends Node2D

@onready var ClumpTrashFolder = $ClumpTrashFolder
var clump_trash_node = preload("res://clump_trash.tscn")

const INITIAL_SPAWN_PERCENT = 0.4
const SPAWN_TIME_RANGE = 0.8
const SPAWN_ZONE = Vector2(1920, 1080)
const SPAWN_BORDER_MARGIN = 160
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


### trash sprites
var trash_sprites = Dictionary()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalManager.connect("SpawnTrash", _on_spawn_trash)
	GlobalManager.connect("ResetLevel", _on_reset_level)
	
	print("/tm1 attempt to start sprite load:")
	for item in ResourceLoader.list_directory("res://Sprites/Trash/"):
		print("/tm1 loading res://Sprites/Trash/" + item)
		var sprite = ResourceLoader.load("res://Sprites/Trash/" + item)
		trash_sprites[item] = sprite

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
		if trash_node != null:
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
	elem.queue_free()
	calc_trash_percent()

func calc_trash_percent():
	var trash_percent = 0.0 if trash_max <= 0 else trash_cleared / float(trash_max)
	GlobalManager.UpdateTrashPercent.emit(trash_percent)
	

func spawn_rand_trash(drifts_in : bool):
	# demo: https://www.desmos.com/calculator/lmssvon8ha
	var spawn_target = Vector2(randf(), randf())
	spawn_target.x *= (SPAWN_ZONE.x - SPAWN_BORDER_MARGIN * 2)
	spawn_target.y *= (SPAWN_ZONE.y - SPAWN_BORDER_MARGIN * 2)
	spawn_target += (SPAWN_BORDER_MARGIN * Vector2.ONE) - (SPAWN_ZONE / 2)
	
	var spawn_pos = spawn_target
	if (drifts_in):
		spawn_pos = spawn_pos.normalized() + Vector2(randf() - 0.5, randf() - 0.5) # random bs go
		spawn_pos = spawn_pos.normalized() * (SPAWN_ZONE.length() + SPAWN_BORDER_MARGIN * 2)
	
	var new_trash_node = clump_trash_node.instantiate()
	ClumpTrashFolder.add_child(new_trash_node)
	trash_list.append(new_trash_node)
	new_trash_node.global_position = spawn_pos
	
	# new_trash_node.setup(sprite, health, reward_value, spawn_target, trash_manager_ref)
	if (randf() < 0.7):
		# small trash
		match randi_range(1, 8):
			1,2:
				var sprite = ["bottle1.png","bottle2.png","bottle3.png","bottle4.png"].pick_random()
				new_trash_node.setup(trash_sprites[sprite], randi_range(5,7), randi_range(1,2), spawn_target, self, 1.5)
			3:
				var sprite = ["crate1.png","crate2.png"].pick_random()
				new_trash_node.setup(trash_sprites[sprite], randi_range(7,10), randi_range(3,5), spawn_target, self, 2)
			4:
				new_trash_node.setup(trash_sprites["tire1.png"], randi_range(10,14), randi_range(4,7), spawn_target, self, 2)
			5:
				var sprite = ["pile1.png","pile2.png"].pick_random()
				new_trash_node.setup(trash_sprites[sprite], randi_range(6,16), randi_range(3,8), spawn_target, self, 3)
			6:
				new_trash_node.setup(trash_sprites["frisbee1.png"], randi_range(8,14), randi_range(3,6), spawn_target, self, 1.5)
			7:
				new_trash_node.setup(trash_sprites["grate1.png"], randi_range(7,10), randi_range(3,5), spawn_target, self, 2)
			8:
				new_trash_node.setup(trash_sprites["net1.png"], randi_range(12,20), randi_range(7,10), spawn_target, self, 3)
	else:
		# large trash
		var sprite = ["pile3.png","pile4.png","pile5.png","pile6.png"].pick_random()
		new_trash_node.setup(trash_sprites[sprite], randi_range(24,40), randi_range(12,20), spawn_target, self,5)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# check spawn queue for scheduled trash that should drift in
	if not spawn_queue_times.is_empty():
		var game_time_elapsed = GlobalManager.gametime.get_wait_time() - GlobalManager.gametime.get_time_left()
		# spawn trash for all timestamps passed
		while (not spawn_queue_times.is_empty() and game_time_elapsed >= spawn_queue_times[0]):
			spawn_queue_times.remove_at(0)
			spawn_rand_trash(true)
