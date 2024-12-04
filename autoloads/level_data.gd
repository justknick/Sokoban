extends Node

const LEVEL_DATA_PATH: String = "res://data/level_data.json"
const TILE_SIZE: int = 32

var _level_data: Dictionary = {} 
# _level_data dictionary will have: level as key, LevelLayout class -> level: LevelLayout
# use "level" as string


func _ready() -> void:
	load_level_data()
	pass


func setup_level(level_number_string_key: String, raw_level_data: Dictionary) -> LevelLayout: 
	var layout: LevelLayout = LevelLayout.new()
	
	var layout_player_start = raw_level_data.player_start
	#layout.set_player_start(layout_player_start["x"], layout_player_start["y"])
	layout.set_player_start(layout_player_start.x, layout_player_start.y)
	
	return layout


#load out json, iterate through it
func load_level_data() -> void: 
	var file = FileAccess.open(LEVEL_DATA_PATH, FileAccess.READ)
	var raw_data = JSON.parse_string(file.get_as_text())
	
	for level_number_string in raw_data.keys():
		
		#var new_level_layout: LevelLayout = setup_level(level_number_string, raw_data[level_number_string])
		#print("new level layout: %s %d, %d" % [
			#new_level_layout.get_instance_id(), 
			#new_level_layout.get_player_start().x, 
			#new_level_layout.get_player_start().y
		#])
		
		#_level_data[level_number_string] = level_number_string + "_value"
		_level_data[level_number_string] = setup_level(level_number_string, raw_data[level_number_string])
