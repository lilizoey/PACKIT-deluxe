extends Area2D

class_name Item

signal drop_item(position, item)
signal pickup_item(item)

var follow_mouse: bool = false
var mouse_offset: Vector2 = Vector2(0,0)
var origin: Vector2 = Vector2(0,0)

var collision_tile_mask: ItemHelpers.CollisionMask = ItemHelpers.collider_1x1()

func _ready():
	origin = global_position

func _process(delta):
	if follow_mouse:
		follow_mouse = Input.is_action_pressed("ui_select")
		if not follow_mouse:
			emit_signal("drop_item", global_position, self)
	
	if follow_mouse:
		global_position = get_global_mouse_position() + mouse_offset
	else:
		global_position = origin

func _on_Item_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			follow_mouse = true
			mouse_offset = global_position - get_global_mouse_position()
			emit_signal("pickup_item", self)

func set_origin(position: Vector2):
	origin = position

func size() -> Vector2:
	return collision_tile_mask.size()
