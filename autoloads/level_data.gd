extends Node

const LEVEL_DATA_PATH: String = "res://data/level_data.json"
const TILE_SIZE: int = 32

var _level_data: Dictionary = {} 
# _level_data dictionary will have: level as key, LevelLayout class -> level: LevelLayout
# use "level" as string


func _ready() -> void:
	load_level_data()
	pass


func add_tiles_for_layer(layout: LevelLayout, layer_type: TileLayers.LayerType, tile_coords: Array) -> void:
	for tile_coord in tile_coords:
		layout.add_tile_to_layer(tile_coord.x, tile_coord.y, layer_type)


func setup_level(level_number_string_key: String, raw_level_data: Dictionary) -> LevelLayout: 
	var layout: LevelLayout = LevelLayout.new()
	
	var raw_tiles: Dictionary = raw_level_data.tiles
	
	var layout_player_start = raw_level_data.player_start
	
	# godot style would want to invoke method after declaration, but we'll do it here 
	
	#FLOOR, WALL, TARGET, BOX, TARGET_BOX
	add_tiles_for_layer(layout, TileLayers.LayerType.FLOOR, raw_tiles.Floor)
	add_tiles_for_layer(layout, TileLayers.LayerType.WALL, raw_tiles.Walls)
	add_tiles_for_layer(layout, TileLayers.LayerType.TARGET, raw_tiles.Targets)
	add_tiles_for_layer(layout, TileLayers.LayerType.BOX, raw_tiles.Boxes)
	add_tiles_for_layer(layout, TileLayers.LayerType.TARGET_BOX, raw_tiles.TargetBoxes)
	
	
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


func get_level_data(level_number: String) -> LevelLayout:
	return _level_data[level_number]
	
