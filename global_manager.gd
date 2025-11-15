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
	self.gametime.start(self.gamedata.levels[currentLevelIndex].RoundTime)
	uiToGame()

### LEVEL SETUP
func uiToLevelTransition():
	self.shopLock = true
	self.ChangeShopUIVisibility.emit(false)
	self.ChangeGameUIVisibility.emit(false)
	self.ChangeTransitionUIVisibility.emit(true)
	
func uiToGame():
	self.shopLock = false
	self.ChangeShopUIVisibility.emit(false)
	self.ChangeTransitionUIVisibility.emit(false)
	self.ChangeGameUIVisibility.emit(true)
	
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
