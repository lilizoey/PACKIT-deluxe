extends Node2D


export var size: Vector2 = Vector2(3,3)
export var tile_size: int = 16

var collision_map: ItemHelpers.CollisionMask = ItemHelpers.new_with(size)
var items: Array = [] 

func _ready():
	pass

func _process(delta):
	pass

func world_to_tile(position: Vector2) -> Vector2:
	# Get the tile that is at the position given by the input
	var relative_position = (position - global_position) / tile_size
	var distance_to_edge = size / 2
	return (relative_position + distance_to_edge).floor()

func tile_to_world(position: Vector2) -> Vector2:
	return global_position + (position - size / 2 + Vector2(0.5,0.5)) * tile_size 


func _on_Item_drop_item(position: Vector2, item: Item):
	var tile_position = world_to_tile(position)
	if item.collision_tile_mask.placeable_at(collision_map, tile_position):
		item.set_origin(tile_to_world(tile_position))
		item.collision_tile_mask.place_at(collision_map, tile_position)
		items.append([tile_position, item])
	
func _on_Item_pickup_item(item: Item):
	for arr in items:
		if (arr[1] == item):
			arr[1].collision_tile_mask.remove_at(collision_map, arr[0])
