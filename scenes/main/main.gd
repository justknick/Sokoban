extends Control

const LEVEL_BUTTON = preload("res://scenes/level_button/level_button.tscn")
const LEVEL_BUTTON_ALT = preload("res://scenes/level_button/level_button_alt.tscn")
const LEVEL_COLUMNS: int = 6
const LEVEL_ROWS: int = 5 

@onready var level_buttons_container: GridContainer = $MarginContainer/VBoxContainer/LevelButtonsContainer

func _ready() -> void:
	setup_grid() 


func setup_grid() -> void: 
	for level in range(LEVEL_COLUMNS * LEVEL_ROWS):
		#var level_button: LevelButton = LEVEL_BUTTON.instantiate()
		var level_button: LevelButtonAlt = LEVEL_BUTTON_ALT.instantiate()
		level_button.set_level_number(str(level + 1))
		level_buttons_container.add_child(level_button)
