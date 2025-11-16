extends Control
func _ready() -> void:
	print("TransitionUi initialized")
	GlobalManager.connect("ChangeShopUIVisibility", _on_visibilty_request)

func _on_visibilty_request(visible : bool, gamedata : LevelData):
	print("shop ui visibility set to ",visible)
	self.visible = visible
