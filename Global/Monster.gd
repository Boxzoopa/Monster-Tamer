extends Resource
class_name MonsterData

@export var name: String = "???"
@export var nickname: String
@export var type1: Config.Types = Config.Types.BASIC
@export var type2: Config.Types = type1
@export_file("*.png") var battle_sprite: String = "res://assets/monsters/battle/mon_000.png"
@export_file("*.png") var overworld_sprite: String = "res://assets/monsters/overworld/mon_000_o.png"
@export var level: int = 1
@export var exp: int = 0
@export var max_exp: int = 10
@export var health: int = 100
@export var power: int = 10
@export var defence: int = 50
@export var spirit: int = 10
@export var speed: int = 100 #150 is high
@export var accuracy: int = 10
@export_range(1, 15, 1, "1 is easy and 15 is very hard") var Bait_level: int = 1 #1 to 15
@export var danger_level: Config.Danger_level = Config.Danger_level.PASSIVE
@export var scene: PackedScene
@export var skills: Array[SkillData] = []
