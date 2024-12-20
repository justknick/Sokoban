extends Node2D

const SOURCE_ID = 0 

@onready var tile_layers: Node2D = $TileLayers
@onready var floor_tiles: TileMapLayer = $TileLayers/Floor
@onready var wall_tiles: TileMapLayer = $TileLayers/Wall
@onready var targets_tiles: TileMapLayer = $TileLayers/Targets
@onready var boxes_tiles: TileMapLayer = $TileLayers/Boxes
@onready var player: AnimatedSprite2D = $Player
@onready var camera_2d: Camera2D = $Camera2D
@onready var hud: Hud = $HudCanvasLayer/Hud
@onready var game_over_ui: GameOverUI = $HudCanvasLayer/GameOverUI

var _total_moves: int = 0
var _player_tile: Vector2i = Vector2i.ZERO
var _game_over: bool = false 

func _ready() -> void: 
	set_up_level() 
	#create_layer_list()


func _process(delta: float) -> void:
	#move_camera()
	controls()
	movement_direction()


func controls() -> void: 
	if Input.is_action_just_pressed("quit"):
		GameManager.load_main_scene()
	if Input.is_action_just_pressed("reload"):
		#GameManager.on_leve_selected(GameManager.get_level_selected())
		set_up_level()


func movement_direction() -> void: 
	if _game_over == true: 
		return
	
	var movement_input: Vector2i = Vector2i.ZERO
	
	if Input.is_action_just_pressed("right") == true:
		movement_input = Vector2i.RIGHT 
		player.flip_h = false
	if Input.is_action_just_pressed("up") == true:
		movement_input = Vector2i.UP 
	if Input.is_action_just_pressed("left") == true:
		movement_input = Vector2i.LEFT 
		player.flip_h = true
	if Input.is_action_just_pressed("down") == true:
		movement_input = Vector2i.DOWN 
	
	if movement_input != Vector2i.ZERO:
		player_move(movement_input)
		print("movement input ", movement_input)


func place_player_on_map(tile_coord: Vector2i) -> void: 
	var new_position: Vector2 = Vector2(
		tile_coord.x * LevelData.TILE_SIZE, 
		tile_coord.y * LevelData.TILE_SIZE
	) + tile_layers.position
	
	player.position = new_position
	_player_tile = tile_coord


func check_game_progress() -> void: 
	for t in targets_tiles.get_used_cells():
		if cell_is_box(t) == false:
			return
	_game_over = true
	print("game over: ", _game_over)
	game_over_ui.game_over(GameManager.get_level_selected(), _total_moves)
	ScoreSync.level_completed(GameManager.get_level_selected(), _total_moves)


func player_move(move_input: Vector2i) -> void: 
	var new_player_tile = _player_tile + move_input 
	var can_move: bool = true 
	var box_seen: bool = false 
	
	if cell_is_wall(new_player_tile) == true: 
		can_move = false
	
	if cell_is_box(new_player_tile) == true: 
		box_seen = true
		can_move = can_box_move(new_player_tile, move_input)
	
	
	if can_move == true: 
		_total_moves += 1
		hud.set_moves_label(_total_moves)
		if box_seen == true: 
			move_box(new_player_tile, move_input)
		place_player_on_map(new_player_tile)
		check_game_progress()


func cell_is_wall(cell: Vector2i) -> bool: 
	return cell in wall_tiles.get_used_cells()


func cell_is_box(cell: Vector2i) -> bool: 
	return cell in boxes_tiles.get_used_cells()


func call_is_empty(cell: Vector2i) -> bool: 
	return !cell_is_wall(cell) and !cell_is_box(cell) 


func can_box_move(box_tile: Vector2i, direction: Vector2i) -> bool: 
	return call_is_empty(box_tile + direction)


func move_box(boxes_tile: Vector2i, direction: Vector2i) -> void: 
	# checking if box can move will be done in the player_move()
	var new_box_tile = boxes_tile + direction 
	
	boxes_tiles.erase_cell(boxes_tile)
	
	if new_box_tile in targets_tiles.get_used_cells():
		boxes_tiles.set_cell(
			new_box_tile, 
			SOURCE_ID, 
			get_atlas_coordinates_for_layer_type(TileLayers.LayerType.TARGET_BOX)
		)
	else:
		boxes_tiles.set_cell(
			new_box_tile, 
			SOURCE_ID, 
			get_atlas_coordinates_for_layer_type(TileLayers.LayerType.BOX)
		)


func create_layer_list() -> void: 
	var layer_list = TileLayers.new().get_layer_type_list()
	print("layer list: ", layer_list)


func get_atlas_coordinates_for_layer_type(layer_type: TileLayers.LayerType) -> Vector2i: 
	match layer_type: 
		# FLOOR, WALL, TARGET, BOX, TARGET_BOX
		TileLayers.LayerType.FLOOR:
			return Vector2i(randi_range(3,8), 0)
		TileLayers.LayerType.WALL:
			return Vector2i(2, 0)
		TileLayers.LayerType.BOX:
			return Vector2i(1, 0)
		TileLayers.LayerType.TARGET:
			return Vector2i(9, 0)
		TileLayers.LayerType.TARGET_BOX:
			return Vector2i(0, 0)
	return Vector2i.ZERO


func add_tile( 
			layer_type: TileLayers.LayerType, 
			tile_coord: Vector2i, 
			map_layer: TileMapLayer
		) -> void: 
	var atlas_coordinate: Vector2i = get_atlas_coordinates_for_layer_type(layer_type)
	map_layer.set_cell(tile_coord, SOURCE_ID, atlas_coordinate)


func setup_layer(layer_type: TileLayers.LayerType, 
		map_layer: TileMapLayer, level_layout: LevelLayout) -> void:
	var tiles_array: Array[Vector2i] = level_layout.get_tiles_for_layer(layer_type)
	for tile_coord in tiles_array:
		add_tile(layer_type, tile_coord, map_layer)


func clear_tiles() -> void: 
	for tile_layer in tile_layers.get_children(): 
		tile_layer.clear()


func camera_size(tile_map_rect: Rect2i) -> Rect2i: 
	var tile_map_width: Rect2i
	var tile_map_width_x: float = tile_map_rect.size.x * LevelData.TILE_SIZE
	var tile_map_width_y: float = tile_map_rect.size.y * LevelData.TILE_SIZE
	return tile_map_width


func move_camera() -> void: 
	var tile_map_rect: Rect2i = floor_tiles.get_used_rect()
	
	#var tile_map_width = camera_size(tile_map_rect)
	#print(tile_map_width)
	var tile_map_width_x: float = tile_map_rect.size.x * LevelData.TILE_SIZE
	var tile_map_width_y: float = tile_map_rect.size.y * LevelData.TILE_SIZE
	
	
	var mid_point_x: float = (tile_map_width_x / 2) + (tile_map_rect.position.x * LevelData.TILE_SIZE)
	var mid_point_y: float = (tile_map_width_y / 2) + (tile_map_rect.position.y * LevelData.TILE_SIZE)
	
	camera_2d.position = Vector2(mid_point_x, mid_point_y)


func set_up_level() -> void: 
	var level_number: String = GameManager.get_level_selected()
	var layout: LevelLayout = LevelData.get_level_data(level_number)
	
	_game_over = false
	_total_moves = 0 
	hud.set_moves_label(_total_moves)
	hud.new_game(level_number)
	game_over_ui.new_game()
	
	clear_tiles()
	#now involke setup layer function
	setup_layer(TileLayers.LayerType.FLOOR, floor_tiles, layout)
	setup_layer(TileLayers.LayerType.WALL, wall_tiles, layout)
	setup_layer(TileLayers.LayerType.TARGET, targets_tiles, layout)
	setup_layer(TileLayers.LayerType.BOX, boxes_tiles, layout)
	setup_layer(TileLayers.LayerType.TARGET_BOX, boxes_tiles, layout)
	
	place_player_on_map(layout.get_player_start())
	
	move_camera()
