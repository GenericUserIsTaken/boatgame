extends Control
func _ready() -> void:
	print("TransitionUi initialized")
	GlobalManager.connect("ChangeTransitionUIVisibility", _on_visibilty_request)

func _on_visibilty_request(visible : bool, gamedata : LevelData):
	print("transition ui visibility set to ",visible)
	self.visible = visible
