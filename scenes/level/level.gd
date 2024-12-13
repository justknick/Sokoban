extends Node2D

const SOURCE_ID = 0 

@onready var tile_layers: Node2D = $TileLayers
@onready var floor_tiles: TileMapLayer = $TileLayers/Floor
@onready var wall_tiles: TileMapLayer = $TileLayers/Wall
@onready var targets_tiles: TileMapLayer = $TileLayers/Targets
@onready var boxes_tiles: TileMapLayer = $TileLayers/Boxes
@onready var player: AnimatedSprite2D = $Player
@onready var camera_2d: Camera2D = $Camera2D

var _total_moves: int = 0


func _ready() -> void: 
	set_up_level() 
	#create_layer_list()


func _process(delta: float) -> void:
	#move_camera()
	pass


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
	
	_total_moves = 0 
	
	clear_tiles()
	#now involke setup layer function
	setup_layer(TileLayers.LayerType.FLOOR, floor_tiles, layout)
	setup_layer(TileLayers.LayerType.WALL, wall_tiles, layout)
	setup_layer(TileLayers.LayerType.TARGET, targets_tiles, layout)
	setup_layer(TileLayers.LayerType.BOX, boxes_tiles, layout)
	setup_layer(TileLayers.LayerType.TARGET_BOX, boxes_tiles, layout)
	
	move_camera()
