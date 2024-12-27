extends Resource
class_name Item

@export var item_name: String = ""
@export var sprite: Texture2D = AtlasTexture.new()


func _to_string() -> String:
	return item_name
