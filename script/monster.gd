extends "res://script/character.gd"

@export var monster_data: MonsterData

enum States { PASSIVE, AGGRESSIVE, CALM }
@export var current_state: States = States.PASSIVE

var passive_speed: int
var aggressive_speed: int
var danger_lvl

var bait_hp: int
var calmed_down: bool = false
var chill_timer_running: bool = false

@onready var detection_area: Area2D = $"Detection Area"
@onready var collision_shape: CollisionShape2D = $"Detection Area/CollisionShape2D"
@export var detection_range: int = 32
@export var chill_timer: float = 60
@export var main_state: States = States.PASSIVE

func _ready() -> void:
	# Ensure monster_data is valid before accessing its properties
	if monster_data != null:
		danger_lvl = monster_data.danger_level
		passive_speed = monster_data.speed / 6
		aggressive_speed = monster_data.speed / 2
		bait_hp = monster_data.Bait_level
	else:
		print("Error: monster_data is not assigned!")
	
	# Update the radius of the detection area
	collision_shape.shape.radius = detection_range

func _physics_process(delta: float) -> void:
	match current_state:
		States.AGGRESSIVE:
			handle_aggressive_state(delta)
		States.PASSIVE:
			handle_passive_state(delta)
		States.CALM:
			handle_calm_state(delta)

func handle_aggressive_state(delta: float) -> void:
	collision_shape.disabled = false
	max_speed = aggressive_speed
	
	if not calmed_down and target != null:
		target_movement(target.global_position)
	else:
		max_speed = passive_speed
		auto_movement(delta)

func handle_passive_state(delta: float) -> void:
	collision_shape.disabled = true
	max_speed = passive_speed
	auto_movement(delta)

func handle_calm_state(delta: float) -> void:
	collision_shape.disabled = true
	max_speed = 0  # No movement in CALM state
	if not chill_timer_running:
		chill_timer_running = true
		start_chill_timer()

func start_chill_timer() -> void:
	# Run the chill timer to reset the state after calming down
	await get_tree().create_timer(chill_timer).timeout
	calmed_down = false
	chill_timer_running = false
	current_state = main_state
	bait_hp = monster_data.Bait_level
	print("Chill timer ended. Returning to main state:", main_state)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body
		if not calmed_down:
			match danger_lvl:
				Config.Danger_level.PASSIVE:
					current_state = States.PASSIVE
					collision_shape.shape.radius = 0
				Config.Danger_level.SEMI_HOSTILE, Config.Danger_level.HOSTILE:
					current_state = States.AGGRESSIVE
		else:
			current_state = States.CALM

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = null
		if not calmed_down:
			current_state = States.AGGRESSIVE
		else:
			current_state = States.CALM

func tame(dmg: int):
	bait_hp -= dmg
	if bait_hp <= 0:
		calmed_down = true
		current_state = States.CALM
		print("Monster calmed down.")
