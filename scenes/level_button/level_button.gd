extends NinePatchRect

class_name LevelButton

@onready var level_label: Label = $LevelLabel

var _level_number: String = "##"


func _ready() -> void:
	level_label.text = _level_number 


func set_level_number(level_number: String) -> void: 
	_level_number = level_number


func get_level_number() -> String:
	return _level_number


func _on_gui_input(event: InputEvent) -> void:
	#print("event : ", event)
	if event.is_action_pressed("select") == true: 
		SignalManager.on_level_selected.emit(_level_number)
		print("you selected level ", _level_number)
