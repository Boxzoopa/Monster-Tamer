extends "res://script/character.gd"

@export var monster_data: MonsterData

enum States { PASSIVE, AGGRESSIVE, CALM }
@export var current_state: States = States.PASSIVE

var passive_speed: int
var aggressive_speed: int
var danger_lvl

var bait_hp: int
var calmed_down: bool = false
var player: Node2D = null

@onready var detection_area: Area2D = $"Detection Area"
@onready var collision_shape: CollisionShape2D = $"Detection Area/CollisionShape2D"
@export var detection_range: int = 32

func _ready() -> void:
	# Ensure monster_data is valid before accessing its properties
	if monster_data != null:
		danger_lvl = monster_data.danger_level
		passive_speed = monster_data.speed / 4
		aggressive_speed = monster_data.speed / 2
		bait_hp = monster_data.Bait_level
	else:
		print("Error: monster_data is not assigned!")
	
	# Update the radius of the detection area
	if collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = detection_range
	else:
		print("Error: Detection shape is not a CircleShape2D!")

func _physics_process(delta: float) -> void:
	match current_state:
		States.AGGRESSIVE:
			if player and not calmed_down:
				move_towards_target(player.global_position, aggressive_speed, delta)

func move_towards_target(target_position: Vector2, speed: float, delta: float) -> void:
	input_vector = (target_position - global_position).normalized()
	#print(input_vector)
	# Calculate desired position
	var desired_position = global_position + (input_vector * (speed/10) * delta)
	
	# Smoothly interpolate towards the desired position
	global_position = global_position.lerp(desired_position, accel)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		current_state = States.AGGRESSIVE
		
		if not calmed_down:
			match danger_lvl:
				Config.Danger_level.PASSIVE:
					current_state = States.PASSIVE
					collision_shape.shape.radius = 0
				Config.Danger_level.SEMI_HOSTILE, Config.Danger_level.HOSTILE:
					current_state = States.AGGRESSIVE
		else:
			#collision_shape.disabled = true
			current_state = States.PASSIVE

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		if not calmed_down:
			current_state = States.PASSIVE
		else:
			#collision_shape.disabled = true
			current_state = States.PASSIVE


func tame(dmg: int):
	bait_hp -= dmg
	
	if bait_hp <= 0:
		calmed_down = true
	
