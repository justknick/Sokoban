extends Node2D

const SOURCE_ID = 0 

@onready var tile_layers: Node2D = $TileLayers
@onready var floor: TileMapLayer = $TileLayers/Floor
@onready var wall: TileMapLayer = $TileLayers/Wall
@onready var targets: TileMapLayer = $TileLayers/Targets
@onready var boxes: TileMapLayer = $TileLayers/Boxes
@onready var player: AnimatedSprite2D = $Player

var _total_moves: int = 0


func _ready() -> void: 
	set_up_level() 


func _process(delta: float) -> void:
	pass 


func clear_tiles() -> void: 
	for tile_layer in tile_layers.get_children(): 
		tile_layer.clear()


func set_up_level() -> void: 
	var level_number: String = GameManager.get_level_selected()
	var layout: LevelLayout = LevelData.get_level_data(level_number)
	
	_total_moves = 0 
	
	clear_tiles()
