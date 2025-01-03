extends "res://script/character.gd"

@export var monster_data: MonsterData

enum States { PASSIVE, AGGRESSIVE, CALM }
@export var current_state: States = States.PASSIVE

var passive_speed: int
var aggressive_speed: int
var danger_lvl: int
var bait_hp: int
var calmed_down: bool = false
var chill_timer_running: bool = false

@onready var detection_area: Area2D = $"Detection Area"
@onready var detection_shape: CollisionShape2D = $"Detection Area/CollisionShape2D"
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hurt_box: Area2D = $HurtBox
@onready var hit_box: Area2D = $HitBox
@onready var trigger: Area2D = $DialogTriggerComponent

@export var detection_range: int = 32
@export var chill_timer: float = 5
@export var main_state: States = States.PASSIVE

@export_group("Taming")
@export_range(0, 100, 1) var recruitment_difficulty = 0
#0, very easy, 100 very hard

@onready var extra_considerations = {
	"monster_name" : monster_data.name,
	"success" : true,
	"player_name": Config.player_name,
	"tame_success": false
}

func _ready() -> void:
	if monster_data != null:
		danger_lvl = monster_data.danger_level
		passive_speed = monster_data.speed / 6
		aggressive_speed = monster_data.speed / 2
		bait_hp = monster_data.Bait_level
		max_hp = monster_data.health
		hp = max_hp
		defence = monster_data.defence
		sprite.play(str(monster_data.dex_num))
	else:
		Config.debug_msg("Error: monster_data is not assigned!")
	detection_shape.shape.radius = detection_range

func _physics_process(delta: float) -> void:
	match current_state:
		States.AGGRESSIVE:
			handle_aggressive_state(delta)
		States.PASSIVE:
			handle_passive_state(delta)
		States.CALM:
			handle_calm_state(delta)
	
	check_status()

func handle_aggressive_state(delta: float) -> void:
	detection_shape.disabled = false
	hit_box.disabled = false
	max_speed = aggressive_speed
	if not calmed_down and target != null:
		target_movement(target.global_position)
	else:
		max_speed = passive_speed
		auto_movement(delta)

func handle_passive_state(delta: float) -> void:
	detection_shape.disabled = true
	hit_box.disabled = false
	max_speed = passive_speed
	auto_movement(delta)

func handle_calm_state(delta: float) -> void:
	detection_shape.disabled = true
	hit_box.disabled = true
	max_speed = 0
	
	if trigger.check_dialog():
		#taming
		randomize()
		Config.current_monster = monster_data.name
		var roll = randi_range(0, 100)
		if roll >= (recruitment_difficulty - Config.player_lvl):
			extra_considerations["success"] = true
		else:
			extra_considerations["success"] = false
		trigger.start_dialog(trigger.dialog, extra_considerations)
		
		if extra_considerations["success"]:
			Config.debug_msg("Tamed a Monster!!")
		
		
	if not chill_timer_running:
		chill_timer_running = true
		start_chill_timer()

func start_chill_timer() -> void:
	await get_tree().create_timer(chill_timer).timeout
	calmed_down = false
	chill_timer_running = false
	current_state = main_state
	bait_hp = monster_data.Bait_level
	Config.debug_msg(str("Chill timer ended. Returning to main state:", main_state))

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body
		if not calmed_down:
			if danger_lvl == Config.Danger_level.PASSIVE:
				current_state = States.PASSIVE
				detection_shape.shape.radius = 0
			else:
				current_state = States.AGGRESSIVE
		else:
			current_state = States.CALM

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = null
		current_state = States.CALM if calmed_down else States.AGGRESSIVE

func tame(damage: int):
	bait_hp -= damage
	if bait_hp <= 0:
		calmed_down = true
		current_state = States.CALM
		Config.debug_msg("Monster calmed down.")
	
	return damage

func _on_hurt_box_area_entered(hitbox: Area2D) -> void:
	if hitbox.is_in_group("Bait"):
		Config.debug_msg("tame!")
		var dmg = tame(hitbox.damage)
		recieve_kb(hitbox.global_position, dmg)
		
	elif hitbox.is_in_group("Harmful"):
		Config.debug_msg("Harmed!")
		var dmg = damage(hitbox.damage)
		recieve_kb(hitbox.global_position, dmg)


func _on_monster_died() -> void:
	Config.debug_msg("Monster Killed!")


func _on_dialog_trigger_component_dialog_finished() -> void:
	Config.debug_msg("killing monster now...")
	hp = 0
	
	var dex_prev = Hud.get_node("UI/DexPrev")
	dex_prev.load_data(monster_data)
	dex_prev.show_entry()
