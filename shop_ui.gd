extends Control
func _ready() -> void:
	print("TransitionUi initialized")
	GlobalManager.connect("ChangeShopUIVisibility", _on_visibilty_request)

@warning_ignore("shadowed_variable_base_class")
func _on_visibilty_request(visible : bool, _gamedata : LevelData):
	print("shop ui visibility set to ",visible)
	self.visible = visible
