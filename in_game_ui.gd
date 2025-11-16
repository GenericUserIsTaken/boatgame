extends Control
func _ready() -> void:
	print("InGameUi initialized")
	GlobalManager.connect("ChangeGameUIVisibility", _on_visibilty_request)


func _on_visibilty_request(visible : bool):
	self.visible = visible

func _process(delta: float) -> void:
	#$Time.text = "{0}:{1}".format([(GlobalManager.gametime.time_left),GlobalManager.gametime.time_left%60.0])
	var minutes = int(GlobalManager.gametime.get_time_left() / 60)
	var seconds = int(fmod(GlobalManager.gametime.get_time_left(), 60.0))
	$Time.text = "%02d:%02d" % [minutes, seconds]
	print(GlobalManager.gametime.get_time_left())
	#print(GlobalManager.gametime.get_wait_time())
	
	#0:00
	#GlobalManager.gametime.time_left
