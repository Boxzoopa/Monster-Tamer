extends Node

const tile_size = 16
enum Types {
	BASIC, NATURE, FIRE, AQUA,
	VOLT, BRAWN, BRAINS, TERROR,
	FROST, METAL, MINERAL,
	MYSTICAL, AIR
}

enum Danger_level {
	PASSIVE, SEMI_HOSTILE, HOSTILE
}

enum Bait_size {
	SMALL, MEDIUM, LARGE, EXTRA_LARGE
}

var print_debug = true # prints out any debug msg

func debug_msg(msg):
	if print_debug == true:
		print('[DEBUG] ' + msg)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
