extends Control
func _ready() -> void:
	print("TransitionUi initialized")
	GlobalManager.connect("ChangeTransitionUIVisibility", _on_visibilty_request)

@warning_ignore("shadowed_variable_base_class")
func _on_visibilty_request(visible : bool, gamedata : LevelData):
	print("transition ui visibility set to ",visible)
	self.visible = visible
	setYear(str(gamedata.Year))
	setDescription(str(gamedata.facts))
	#start tween

func setYear(text : String):
	$Panel/MarginContainer/VBoxContainer/HBoxContainer/Label.text = text

func setDescription(text : String):
	$Panel/MarginContainer/VBoxContainer/RichTextLabel.text = text
