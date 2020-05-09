extends Area2D

class_name Item

signal drop_item(position, item)
signal pickup_item(item)

var follow_mouse: bool = false
var mouse_offset: Vector2 = Vector2(0,0)
var origin: Vector2 = Vector2(0,0)
var collision_tile_mask: ItemHelpers.CollisionMask = ItemHelpers.collider_1x1()

var original_rotation: int = 0
var rotations: int = 0
var placed: bool = false
var keep_rotation: bool = false

func _ready():
	origin = global_position

func _process(delta):
	if follow_mouse:
		follow_mouse = Input.is_action_pressed("ui_select")
		if Input.is_action_just_pressed("item_rotate"):
			rotate_clockwise()
		if not follow_mouse:
			before_drop()
			emit_signal("drop_item", global_position - offset(), self)
			after_drop()
	
	if follow_mouse:
		global_position = get_global_mouse_position() + mouse_offset
	else:
		global_position = origin

func _on_Item_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			before_pickup()
			follow_mouse = true
			mouse_offset = global_position - get_global_mouse_position()
			emit_signal("pickup_item", self)
			after_pickup()

func set_origin(new_position: Vector2):
	origin = new_position
	global_position = new_position

func drop_at(tile_position: Vector2):
	set_origin(tile_position + offset())

func size() -> Vector2:
	return collision_tile_mask.size()

func offset() -> Vector2:
	return (size() - Vector2(1,1)) * Constants.TILE_SIZE / 2

func rotate_clockwise():
	collision_tile_mask = ItemHelpers.rotate_clockwise(collision_tile_mask)
	rotations += 1
	rotations = rotations % 4
	rotation = (PI / 2) * rotations

func before_pickup():
	original_rotation = rotations
	placed = false

func after_pickup():
	pass

func before_drop():
	pass

func after_drop():
	if keep_rotation and not placed:
		revert_rotation()

func revert_rotation():
	while rotations != original_rotation:
		rotate_clockwise()

func place():
	placed = true
	keep_rotation = true
