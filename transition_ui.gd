extends Control

#really gross lookup table, can totally do this way better
var barArray : Dictionary[int,float] = {\
 1960 : 1.31,\
 1980 : 4.21,\
 2000 : 19.3,\
 2020 : 45.68,\
 2040 : 100.0
} 

func _ready() -> void:
	print("TransitionUi initialized")
	GlobalManager.connect("ChangeTransitionUIVisibility", _on_visibilty_request)
	resetBars()
	await get_tree().create_timer(0.4).timeout #fix the ui not being initialized in time
	tweenAllBars(1.5)

func resetBars():
	for i in barArray.keys():
		findBar(i).value = 0

func tweenAllBars(speed : float):
	for i in barArray.keys():
		tweenBar(i,barArray.get(i),speed)
	

func findBar(year:int):
	var container = $Panel/MarginContainer/VBoxContainer/Panel/MarginContainer/HBoxContainer2/HBoxContainer
	assert(container != null)
	var test = "{0}Bar".format([year])
	var find = container.find_child(test,true)
	return find

func tweenBar(year:int,to:float,time:float):
	var tween = get_tree().create_tween()
	tween.tween_property(findBar(year), "value", to, time)
	#tween.tween_property($Sprite, "scale", Vector2(), 1.0)
	#tween.tween_callback($Sprite.queue_free)

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
