class_name TileLayers


enum LayerType { FLOOR, WALL, TARGET, BOX, TARGET_BOX }
# target_box will be on the box layer


var _floor: Array[Vector2i]
var _wall: Array[Vector2i]
var _target: Array[Vector2i]
var _box: Array[Vector2i]
var _target_box: Array[Vector2i]

# setup a dictionary that will lookup each of the values 
# keys are the layer type, the values are the particular layer
var _layer_coordinates: Dictionary = {
	LayerType.FLOOR: _floor, 
	LayerType.WALL: _wall, 
	LayerType.TARGET: _target, 
	LayerType.BOX: _box, 
	LayerType.TARGET_BOX: _target_box
}


# add coord to one of the lists
func add_coordinate(coord: Vector2i, layer_type: LayerType) -> void: 
	_layer_coordinates[layer_type].push_back(coord)
