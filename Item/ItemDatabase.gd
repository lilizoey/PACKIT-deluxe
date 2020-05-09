extends Node

const itemList = []
const database = {}

enum Tags {
	NORMAL,
	SALMON,
	OCCULT,
	LEWD,
	MAIL,
}

class ItemData:
	var Tags = Tags
	var name: String
	var sprite_path: String
	var collision: ItemHelpers.CollisionMask
	var tags: Array
	
	func add_to_database():
		for tag in tags:
			if not database.has(tag):
				database[tag] = []
			database[tag].append(self)
			itemList.append(self)
	
	func _init(name: String, 
		description: String,
		sprite_path: String, 
		collision_map: Array,
		tags: Array):
		self.name = name
		self.sprite_path = sprite_path
		collision = ItemHelpers.CollisionMask.new(collision_map)
		self.tags = tags
		add_to_database()

func _init():
	ItemData.new("Mail Box",
		"As opposed to the fe-mail box.",
		"res://Sprites/Items/item1x1MailBox.png",
		[[true]],
		[Tags.NORMAL, Tags.MAIL])
	ItemData.new("Boomerang",
		"OK Boomerang.",
		"res://Sprites/Items/item2x2LBoomerang.png",
		[[true,true],[false,true]],
		[Tags.NORMAL])
	ItemData.new("Orange Can",
		"But apple cannot.",
		"res://Sprites/Items/item1x1CanOrange.png",
		[[true]],
		[Tags.NORMAL])
	ItemData.new("Calculator",
		"Better calculator than calcunever.",
		"res://Sprites/Items/item1x1Calculator.png",
		[[true]],
		[Tags.NORMAL])

static func get_random():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return itemList[rng.randi_range(0,itemList.size() - 1)]

static func get_by_name(name: String):
	for item in itemList:
		if item.name == name:
			return item
	return null

static func get_by_tag(tag):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return database[tag][rng.randi_range(0,database[tag].size() - 1)]
