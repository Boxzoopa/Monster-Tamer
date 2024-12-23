extends Node

const tile_size = 16
enum Types {
	BASIC, NATURE, FIRE, AQUA,
	ELECTRIC
}

enum Danger_level {
	PASSIVE, SEMI_HOSTILE, HOSTILE
}

enum Bait_size {
	SMALL, MEDIUM, LARGE, EXTRA_LARGE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
