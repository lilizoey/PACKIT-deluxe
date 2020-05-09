extends Node

const COLLIDER_NODE = preload("res://Item/TileCollider.tscn")

func _ready():
	var bool_map = get_parent().collision_tile_mask.bool_map
	
	for x in range(0,bool_map.size()):
		for y in range(0,bool_map[0].size()):
			if bool_map[x][y]:
				var new_node = COLLIDER_NODE.instance()
				var tile_position = Vector2(x,y) - (get_parent().size() - Vector2(1,1)) / 2.0
				new_node.position = tile_position * Constants.TILE_SIZE
				get_parent().call_deferred("add_child", new_node)
	
	get_parent().call_deferred("remove_child", self)
