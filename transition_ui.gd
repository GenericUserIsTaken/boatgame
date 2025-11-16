extends Control

#really gross lookup table, can totally do this way better
var barDict : Dictionary[int,float] = {\
 1960 : 1.31,\
 1980 : 4.21,\
 2000 : 19.3,\
 2020 : 45.68,\
 2040 : 100.0
} 

var tweenDict : Dictionary[int,Tween] = {} 

func _ready() -> void:
	print("TransitionUi initialized")
	GlobalManager.connect("ChangeTransitionUIVisibility", _on_visibilty_request)
	resetBars()
	print("reset bars")
	await get_tree().create_timer(0.4).timeout #fix the ui not being initialized in time
	print("tweening bars")
	tweenAllBars(2)

func resetBars():
	for i in barDict.keys():
		findBar(i).value = 0

func tweenAllBars(speed : float):
	for i in barDict.keys():
		tweenBar(i,barDict.get(i),speed)
	

func findBar(year:int):
	var container = $Panel/MarginContainer/VBoxContainer/Panel/MarginContainer/HBoxContainer2/HBoxContainer
	assert(container != null)
	var test = "{0}Bar".format([year])
	var find = container.find_child(test,true)
	return find

func findControl(year:int):
	var container = $Panel/MarginContainer/VBoxContainer/Panel/MarginContainer/HBoxContainer2/HBoxContainer
	assert(container != null)
	var test = "{0}Control".format([year])
	var find = container.find_child(test,true)
	return find

func tweenBar(year:int,to:float,time:float):
	if not tweenDict.has(year):
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUINT)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(findBar(year), "value", to, time).from(0.0)
		tweenDict[year] = tween
	else:
		tweenDict.get(year).stop() #WARNING if alt tabbed then it doesn't work
		tweenDict.get(year).play() #WARNING E 0:00:32:289   transition_ui.gd:55 @ tweenBar(): Tween invalid. Either finished or created outside scene tree.
	#tween.tween_property($Sprite, "scale", Vector2(), 1.0)
	#tween.tween_callback($Sprite.queue_free)

@warning_ignore("shadowed_variable_base_class")
func _on_visibilty_request(visible : bool, gamedata : LevelData):
	resetBars()
	print("Reset Bars")
	print("transition ui visibility set to ",visible)
	self.visible = visible
	setDescription(str(gamedata.facts))
	setYear(str(gamedata.Year))
	#await get_tree().create_timer(0.4).timeout #fix the ui not being initialized in time
	var control = findControl(gamedata.Year)
	control.visible = true
	print("Reanimate Bars")
	tweenAllBars(2)
	#start tween

func setYear(text : String):
	$Panel/MarginContainer/VBoxContainer/HBoxContainer/Label.text = text
	

func setDescription(text : String):
	$RichTextLabel.text = text
