extends Control
var speedDisplay
var rangeDisplay
var efficiencyDisplay
var moneyDisplay

func _ready() -> void:
	print("TransitionUi initialized")
	GlobalManager.connect("ChangeShopUIVisibility", _on_visibilty_request)
	speedDisplay = $Panel/HBoxContainer/Panel/VBoxContainer/Panel/VBoxContainer/Label
	rangeDisplay = $Panel/HBoxContainer/Panel/VBoxContainer/Panel/VBoxContainer/Label2
	efficiencyDisplay = $Panel/HBoxContainer/Panel/VBoxContainer/Panel/VBoxContainer/Label3
	moneyDisplay = $Panel/HBoxContainer/Panel2/VBoxContainer/Panel/HBoxContainer/CenterContainer/MoneyValue
	
@warning_ignore("shadowed_variable_base_class")
func _on_visibilty_request(visible : bool, _gamedata : LevelData):
	print("shop ui visibility set to ",visible)
	self.visible = visible
	displayMoney()
	displayNewBoatValues()

func checkMoney(value):
	if GlobalManager.money >= value:
		GlobalManager.money -= value
		return true
	return false

func _on_speed_down() -> void:
	#add money check with variable GlobalManager.money
	if checkMoney(5):
		GlobalManager.Speed += 1.0
	displayMoney()
	displayNewBoatValues()

func _on_range_down() -> void:
	if checkMoney(5):
		GlobalManager.Size += 0.2
	displayMoney()
	displayNewBoatValues()

func _on_efficiency_down() -> void:
	if checkMoney(5):
		GlobalManager.Damage += 1.0
	displayMoney()
	displayNewBoatValues()

func displayMoney():
	moneyDisplay.text = "${0}".format([GlobalManager.money])
	
func displayNewBoatValues():
	speedDisplay.text = "Speed: {0}".format([GlobalManager.Speed])
	rangeDisplay.text = "Range: {0}".format([GlobalManager.Size])
	efficiencyDisplay.text = "Efficiency: {0}".format([GlobalManager.Damage])
