class_name LevelData
extends Resource

@export var Year : int = 1950
@export var BarGraphSize : float = 0.0
@export var BarGraphText : String = "100 metric tons"
@export var RoundTime : float = 60.0
@export var TrashAmount : int = 15
@export var DrawTrashBackground : bool = false

func _init(year = 1950, bargraphsize=0.0, bargraphtext = "100 metric tons", roundtime = 60.0, trashamount = 15, drawtrashbg = false):
	self.Year = year
	self.BarGraphSize = bargraphsize
	self.BarGraphText = bargraphtext
	self.RoundTime = roundtime
	self.TrashAmount = trashamount
	self.DrawTrashBackground = drawtrashbg
