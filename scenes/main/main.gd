extends Control

const LEVEL_BUTTON = preload("res://scenes/level_button/level_button.tscn")
const LEVEL_COLUMNS: int = 6
const LEVEL_ROWS: int = 5 

@onready var level_buttons_container: GridContainer = $MarginContainer/VBoxContainer/LevelButtonsContainer

func _ready() -> void:
	setup_grid() 


func setup_grid() -> void: 
	for level in range(LEVEL_COLUMNS * LEVEL_ROWS):
		var level_button = LEVEL_BUTTON.instantiate()
		level_buttons_container.add_child(level_button)
