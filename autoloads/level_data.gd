extends Node

const LEVEL_DATA_PATH: String = "res://data/level_data.json"
const TILE_SIZE: int = 32

var _level_data: Dictionary = {} 
# _level_data dictionary will have: level as key, LevelLayout class -> level: LevelLayout


func _ready() -> void:
	load_level_data()
	pass


#load out json, iterate through it
func load_level_data() -> void: 
	var file = FileAccess.open(LEVEL_DATA_PATH, FileAccess.READ)
	var raw_data = JSON.parse_string(file.get_as_text())
	
	for level_number_string in raw_data.keys():
		_level_data[level_number_string] = level_number_string + "_value"
