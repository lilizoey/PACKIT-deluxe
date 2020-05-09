extends Node2D

signal done_setup()

export var spawn_delay: float
export var inventory_path: NodePath
export var item_parent_path: NodePath

var inventory_node: Node2D
var item_parent_node: Node2D

func _ready():
	inventory_node = get_node(inventory_path)
	item_parent_node = get_node(item_parent_path) if item_parent_node else get_parent()
	emit_signal("done_setup")

