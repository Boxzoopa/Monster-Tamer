extends Resource
class_name MonsterData

@export_category("Basic Information")
@export var name: String = "???"
@export var nickname: String
@export var type1: Config.Types = Config.Types.BASIC
@export var type2: Config.Types = type1

@export_group("Dex Info")
@export var seen: bool = false
@export var tamed: bool = false
@export_multiline var entry: String = "No Information available"

var dex_sprites_all: CompressedTexture2D = load("res://assets/monsters/battle/monsters-Sheet.png")
@export_range(0, 100) var dex_num: int = 0 
@export var sprite: CompressedTexture2D = load("res://assets/monsters/battle/mon_0.png")

@export_group("Basic stats")
@export var level: int = 1
@export var exp: int = 0
@export var max_exp: int = 10

@export_category("Base Stats")
@export var health: int = 10
@export var power: int = 10
@export var defence: int = 10
@export var soul: int = 10
@export var speed: int = 100 #150 is high

@export_category("Advanced Information")
@export_range(1, 15, 1, "1 is easy and 15 is very hard") var Bait_level: int = 1 #1 to 15
@export var danger_level: Config.Danger_level = Config.Danger_level.PASSIVE
@export var scene: PackedScene

@export var skills: Array[SkillData] = []

@export_range(0, 5, int(1)) var level_curve: int = 0 
# 0 = Super Fast, 1 = Fast, 2 = Medium, 3 = Slow, 4 = Extra Slow


func set_seen_and_tamed():
	seen = true
	tamed = true
