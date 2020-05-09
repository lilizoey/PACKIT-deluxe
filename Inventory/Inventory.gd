extends Node2D

signal dropped_item(item)
signal box_packed(items)

export var size: Vector2 = Vector2(3,3)
export var tile_size: int = 16
export var open_box: Texture
export var closed_box: Texture

var collision_map: ItemHelpers.CollisionMask = ItemHelpers.new_with(size)
var items: Array = [] 

func _ready():
	set_texture(open_box)	

func _process(delta):
	pass

func world_to_tile(position: Vector2) -> Vector2:
	# Get the tile that is at the position given by the input
	var relative_position = (position - global_position) / tile_size
	var distance_to_edge = size / 2
	return (relative_position + distance_to_edge).floor()

func tile_to_world(position: Vector2) -> Vector2:
	var centre = global_position + (position - size / 2 + Vector2(0.5,0.5)) * tile_size
	return centre 

func drop_item_at(tile_position: Vector2, item: Item):
	item.drop_at(tile_to_world(tile_position))
	item.collision_tile_mask.place_at(collision_map, tile_position)
	emit_signal("dropped_item", item)
	item.place()

func _on_Item_drop_item(position: Vector2, item: Item):
	var arr = find_item(item)
	var tile_position = world_to_tile(position)
	print("\n")
	if arr:
		print("before remove: ", collision_map.bool_map)
		remove_arr_item(arr)
		print("after remove: ", collision_map.bool_map)
		if item.collision_tile_mask.placeable_at(collision_map, tile_position):
			drop_item_at(tile_position, item)
			items.append([tile_position, item, item.collision_tile_mask])
		else:
			item.revert_rotation()
			drop_item_at(arr[0], item)
			items.append(arr)
	elif item.collision_tile_mask.placeable_at(collision_map, tile_position):
		drop_item_at(tile_position, item)
		items.append([tile_position, item, item.collision_tile_mask])
	print("after drop: ", collision_map.bool_map)
	
func _on_Item_pickup_item(item: Item):
	pass
	#remove_item(item)

func pack_box() -> Array:
	set_texture(closed_box)
	emit_signal("box_packed", items)
	for item in items:
		item[1].get_parent().remove_child(item[1])
	return items

func set_texture(texture: Texture):
	get_child(0).texture = texture
	
func has_item(item) -> bool:
	for arr in items:
		if arr[1] == item:
			return true
	return false
	
func find_item(item) -> Array:
	for arr in items:
		if arr[1] == item:
			return arr
	return []

func remove_item(item):
	for arr in items:
		if arr[1] == item:
			remove_arr_item(arr)
			
func remove_arr_item(arr):
	arr[2].remove_at(collision_map, arr[0])
	items.erase(arr)
