extends Node

func _ready():
	var sprite: Sprite
	var item = ItemDatabase.get_random()
	
	for child in get_parent().get_children():
		if child is Sprite:
			sprite = child as Sprite
			break
	
	sprite.texture = load(item.sprite_path)
	get_parent().collision_tile_mask = item.collision
