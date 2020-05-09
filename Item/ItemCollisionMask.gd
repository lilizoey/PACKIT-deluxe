class_name ItemHelpers

class CollisionMask:
	var width: int
	var height: int
	var bool_map: Array

	func _init(arr: Array):
		bool_map = arr
		width = arr.size()
		height = arr[0].size()

	func placeable_at(other, position: Vector2) -> bool:
		if other.width < position.x + width or \
			other.height < position.y + height or \
			position.x < 0 or position.y < 0:
			return false
	
		for x in range(0,width):
			for y in range(0,height):
				if bool_map[x][y] and other.bool_map[position.x + x][position.y + y]:
					return false
					
		return true
		
	func place_at(other, position: Vector2):
		for x in range(0,width):
			for y in range(0,height):
				other.bool_map[position.x + x][position.y + y] = bool_map[x][y] or other.bool_map[position.x + x][position.y + y]
	
	func remove_at(other, position: Vector2):
		for x in range(0,width):
			for y in range(0,height):
				if bool_map[x][y]:
					other.bool_map[position.x + x][position.y + y] = false


	func size() -> Vector2:
		return Vector2(width, height)

static func new_with(size: Vector2) -> CollisionMask:
	var mapping = []
	for x in range(0,size.x):
		mapping.append([])
		for y in range(0,size.y):
			mapping[x].append(false)
	return CollisionMask.new(mapping)

static func transposed(map) -> Array:
	var new_map = map.duplicate(true)

	for x in range(0,map.size()):
		for y in range(0,map[0].size()):
				new_map[y][x] = map[x][y]

	return new_map

static func inversed_columns(map) -> Array:
	var new_map = map.duplicate(true)
	for x in range(0,map.size()):
		new_map[x].invert()
	return new_map

static func rotate_clockwise(map) -> CollisionMask:
		var new_map = inversed_columns(map.bool_map)
		new_map = transposed(new_map)

		# 6 7 8
		# 3 4 5
		# 0 1 2
		# becomes:
		# 0 3 6
		# 1 4 7
		# 2 5 8

		return CollisionMask.new(new_map)

static func collider_1x1() -> CollisionMask:
	return CollisionMask.new([[true]])
