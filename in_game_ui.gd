extends Control
func _ready() -> void:
	print("InGameUi initialized")
	GlobalManager.connect("ChangeGameUIVisibility", _on_visibilty_request)
	GlobalManager.connect("UpdateMoney", _on_money_changed)
	GlobalManager.connect("UpdateTrashPercent", _on_trash_changed)
	_on_money_changed()
	_on_trash_changed(100.0)

@warning_ignore("shadowed_variable_base_class")
func _on_visibilty_request(visible : bool, _gamedata : LevelData):
	print("game ui visibility set to ",visible)
	self.visible = visible

func _process(_delta: float) -> void:
	updateTime()

func updateTime():
	var minutes = int(GlobalManager.gametime.get_time_left() / 60)
	var seconds = int(fmod(GlobalManager.gametime.get_time_left(), 60.0))
	$Time.text = "%02d:%02d" % [minutes, seconds]

func _on_money_changed():
	$VBoxContainer/Money.text = "$%01d" % [GlobalManager.money]

func _on_trash_changed(value : float):
	var text = "{0}%".format([String.num(value, 2)])
	$VBoxContainer/TrashCleared.text = text
	
