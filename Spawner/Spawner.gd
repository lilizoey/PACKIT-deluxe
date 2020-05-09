extends Node2D

signal spawn_item(item)

var inventory_node: Node2D
var item_scene = preload("res://Item/Item.tscn")
var spawn_delay: float

var contained_item: Node2D
var timer: float
var item_parent: Node2D

func _ready():
	spawn_delay = get_parent().spawn_delay
	timer = spawn_delay
	get_parent().connect("done_setup", self, "on_Parent_done_setup")

func on_Parent_done_setup():
	inventory_node = get_parent().inventory_node
	inventory_node.connect("dropped_item", self, "_on_Inventory_dropped_item")
	item_parent = get_parent().item_parent_node

func _process(delta):
	timer -= delta
	
	
	if timer <= 0:
		timer = spawn_delay
		try_spawn()
	
func spawn_position() -> Vector2:
	return global_position

func try_spawn():
	if contained_item != null:
		return
	var item = item_scene.instance()
	item.set_origin(spawn_position())
	item_parent.call_deferred("add_child", item)
	contained_item = item
	contained_item.connect("drop_item", inventory_node, "_on_Item_drop_item")
	contained_item.connect("pickup_item", inventory_node, "_on_Item_pickup_item")
	
func _on_Inventory_dropped_item(item):
	if contained_item == item:
		contained_item = null
