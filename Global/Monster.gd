extends Resource
class_name MonsterData

@export var name: String = "???"
@export var nickname: String
@export var type1: Config.Types = Config.Types.BASIC
@export var type2: Config.Types = type1

var dex_sprites_all: CompressedTexture2D = load("res://assets/monsters/battle/monsters-Sheet.png")
@export_range(0, 100) var dex_num: int = 0

@export var level: int = 1
@export var exp: int = 0
@export var max_exp: int = 10

@export var health: int = 100
@export var power: int = 10
@export var defence: int = 50
@export var soul: int = 10
@export var speed: int = 100 #150 is high

@export_range(1, 15, 1, "1 is easy and 15 is very hard") var Bait_level: int = 1 #1 to 15
@export var danger_level: Config.Danger_level = Config.Danger_level.PASSIVE
@export var scene: PackedScene

@export var skills: Array[SkillData] = []

@export_range(0, 5, int(1)) var level_curve: int = 0 
# 0 = Super Fast, 1 = Fast, 2 = Medium, 3 = Slow, 4 = Extra Slow
