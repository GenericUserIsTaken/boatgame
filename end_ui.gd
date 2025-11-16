extends Control
func _ready() -> void:
	print("EndUi initialized")
	GlobalManager.connect("ChangeEndUIVisibility", _on_visibilty_request)

@warning_ignore("shadowed_variable_base_class")
func _on_visibilty_request(visible : bool):
	self.visible = visible
