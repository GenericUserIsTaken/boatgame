extends Node
'''
- hold level timer
- request UI transitions
- request level setup with params
- hold player stats and inventory
- send trash percent to UI
'''

### GAME LOGIC
var gametime : Timer = Timer.new()
var gamedata : GameLevels = preload("res://gamelevels.tres")
var currentLevelIndex : int = 0
var shopLock : bool = true
var shopVis : bool = false

### UI VISIBILITY SIGNALS
signal ChangeGameUIVisibility (Visbile : bool, gamedata : LevelData)
signal ChangeTransitionUIVisibility (Visbile : bool, gamedata : LevelData)
signal ChangeShopUIVisibility (Visbile : bool, gamedata : LevelData)

### LEVEL SETUP
signal ResetLevel ()
signal SpawnTrash (TrashAmount : int, RoundTime : float, SurfaceTrashVisible : bool)

### PLAYER STATS
var Speed : float = 10.0
var Damage : float = 1.0
var Size : float = 5.0
signal UpdatePlayerAttributes (Speed : float, Damage : float, Size : float)
#TODO impplement abilities

### UPDATE UI TRASH PERCENT
signal UpdateTrashPercent (newvalue : float)


##### FUNCTIONS
### GAME LOGIC
func _ready() -> void:
	self.gametime.connect("timeout", _on_timer_timeout)
	self.add_child(self.gametime)
	start_round()
	
func _on_timer_timeout():
	self.currentLevelIndex += 1
	#TODO DOUBLE CHECK THIS IF STATMENT
	if self.currentLevelIndex > self.gamedata.levels.size():
		#TODO ADD END GAME STATE
		printerr("NEED TO END GAME DUMMY")
	uiToLevelTransition(self.gamedata.levels[currentLevelIndex])
	
func start_round():
	var currentlevel = self.gamedata.levels[currentLevelIndex]
	self.gametime.start(currentlevel.RoundTime)
	self.SpawnTrash.emit(currentlevel.TrashAmount,currentlevel.RoundTime,currentlevel.DrawTrashBackground)
	uiToGame(currentlevel)

### UI LOGIC
func uiToLevelTransition(leveldata):
	self.shopLock = true
	self.shopVis = false
	self.ChangeShopUIVisibility.emit(false, leveldata)
	self.ChangeGameUIVisibility.emit(false, leveldata)
	self.ChangeTransitionUIVisibility.emit(true, leveldata)
	
func uiToGame(leveldata):
	self.shopLock = false
	self.shopVis = false
	self.ChangeShopUIVisibility.emit(false, leveldata)
	self.ChangeTransitionUIVisibility.emit(false, leveldata)
	self.ChangeGameUIVisibility.emit(true, leveldata)
	
func toggleShopUI():
	if not self.shopLock:
		self.ChangeShopUIVisibility.emit(not self.shopvis)
		self.shopvis = not self.shopVis
	
### PLAYER STATS
func EmitPlayerSignal():
	self.UpdateTrashPercent.emit(self.Speed,self.Damage,self.Size)
	
func UpdateSpeed(value : float):
	self.Speed = value
	EmitPlayerSignal()
	
func UpdateDamage(value : float):
	self.Damage = value
	EmitPlayerSignal()

func UpdateSize(value : float):
	self.Size = value
	EmitPlayerSignal()

### UPDATE UI TRASH PERCENT
func UpdateTrashPrecent(value:float):
	self.UpdateTrashPercent.emit(value)
