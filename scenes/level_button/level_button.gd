extends NinePatchRect

class_name LevelButton

@onready var level_label: Label = $LevelLabel
@onready var check_mark: TextureRect = $CheckMark

var _level_number: String = "##"


func _ready() -> void:
	display_level_button_labels()


func display_level_button_labels() -> void: 
	level_label.text = _level_number 
	
	if ScoreSync.has_level_score(_level_number) == true: 
		check_mark.show() 


func set_level_number(level_number: String) -> void: 
	_level_number = level_number


func get_level_number() -> String:
	return _level_number


func _on_gui_input(event: InputEvent) -> void:
	#print("event : ", event)
	if event.is_action_pressed("select") == true: 
		SignalManager.on_level_selected.emit(_level_number)
		print("you selected level ", _level_number)
