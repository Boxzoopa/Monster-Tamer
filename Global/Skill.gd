extends Resource
class_name SkillData
@export var name: String = "Skill Name"
@export var type: Config.Types = Config.Types.BASIC
@export var target: String = "Monster" # Could be "Monster" or "Self"
@export var skill_type: String = "Basic" # e.g., "Basic", "Aqua"
@export var damage: int = 0
@export var cost: int = 0
