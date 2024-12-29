extends Node

const tile_size = 16
enum Types {
	BASIC, NATURE, FIRE, AQUA,
	VOLT, BRAWN, BRAINS, TERROR,
	FROST, METAL, EARTH,
	MYSTICAL, AIR, TOXIC
}


const TypeNames = {
	Types.BASIC: "Basic",
	Types.NATURE: "Nature",
	Types.FIRE: "Fire",
	Types.AQUA: "Aqua",
	Types.VOLT: "Volt",
	Types.BRAWN: "Brawn",
	Types.BRAINS: "Brains",
	Types.TERROR: "Terror",
	Types.FROST: "Frost",
	Types.METAL: "Metal",
	Types.EARTH: "Earth",
	Types.MYSTICAL: "Mystical",
	Types.AIR: "Air",
	Types.TOXIC: "Toxic"
}

enum Danger_level {
	PASSIVE, SEMI_HOSTILE, HOSTILE
}

enum Bait_size {
	SMALL, MEDIUM, LARGE, EXTRA_LARGE
}

var print_debug = true # prints out any debug msg
var scale = 1 # camera scale

var current_monster = ""

var player_name = "Kuro"
var player_lvl = 1
var player_hp = 10
var player_coins = 0
var player_baits = 0

var active= true

func debug_msg(msg):
	if print_debug == true:
		print('[DEBUG] ' + msg)
