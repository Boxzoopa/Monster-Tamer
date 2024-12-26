extends CharacterBody2D

enum Type { STATIC, AUTO, CONTROLLABLE, TARGET }

@export var movement_type: Type = Type.STATIC
@export var accel: float = 50  # Acceleration in pixels per second squared
@export var max_speed: float = 100  # Maximum speed in pixels per second
@export var max_auto_timer: float = 1.0  # Duration for movement or stopping
var auto_timer = max_auto_timer
var current_auto_direction: Vector2 = Vector2.ZERO

var input_vector: Vector2 = Vector2.ZERO
var target = null

signal hp_changed(new_hp: int)
signal max_hp_changed(new_hp: int)
signal died

var _max_hp: int
var _hp: int

var max_hp: int:
	set(value):
		set_max_hp(value)
	get:
		return _max_hp

var hp: int:
	set(value):
		set_hp(value)
	get:
		return _hp
var defence: int

func _physics_process(delta: float) -> void:
	match movement_type:
		Type.STATIC:
			static_movement()
		Type.AUTO:
			auto_movement(delta)
		Type.CONTROLLABLE:
			controllable_movement()
		Type.TARGET:
			if target != null:
				target_movement(target.global_position)
	
	if hp <= 0:
		emit_signal("died")


func static_movement() -> void:
	input_vector = Vector2.ZERO
	velocity = Vector2.ZERO

func auto_movement(delta: float) -> void:
	input_vector = process_auto(delta)
	move(input_vector, delta)

func controllable_movement() -> void:
	input_vector = process_input()
	move(input_vector)

func target_movement(target_pos: Vector2) -> void:
	input_vector = process_target_position(target_pos)
	move(input_vector)


func move(input_direction: Vector2, delta: float = 1.0) -> void:
	velocity.x = move_toward(velocity.x, max_speed * input_direction.x, accel)
	velocity.y = move_toward(velocity.y, max_speed * input_direction.y, accel)
	move_and_slide()


func process_input() -> Vector2:
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	return input_direction.normalized()

func process_auto(delta: float) -> Vector2:
	auto_timer -= delta
	if auto_timer <= 0.0:
		current_auto_direction = choose_random_direction()
		auto_timer = max_auto_timer
	return current_auto_direction

func choose_random_direction() -> Vector2:
	match randi() % 8:
		0: return Vector2.LEFT
		1: return Vector2.RIGHT
		2: return Vector2.UP
		3: return Vector2.DOWN
		_: return Vector2.ZERO

func process_target_position(target_pos: Vector2) -> Vector2:
	return (target_pos - global_position).normalized()


func _on_died() -> void:
	queue_free()

func set_max_hp(value: int) -> void:
	if value != _max_hp:
		_max_hp = max(0, value)
		emit_signal("max_hp_changed", _max_hp)
		_hp = clamp(_hp, 0, _max_hp)  # Ensure HP does not exceed the new max HP

func set_hp(value: int) -> void:
	if value != _hp:
		_hp = clamp(value, 0, _max_hp)
		emit_signal("hp_changed", _hp)

func damage(base_dmg: int):
	var actual_damage = base_dmg
	actual_damage -= defence
	
	self.hp -= actual_damage
	
	Config.debug_msg(str(self.hp))
	
	if hp <= 0:
		emit_signal("died")
