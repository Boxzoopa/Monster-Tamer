extends CharacterBody2D

enum Type { STATIC, AUTO, CONTROLLABLE, TARGET }

@export var movement_type: Type = Type.STATIC
@export var accel: float = 50  # Acceleration in pixels per second squared
@export var max_speed: float = 100  # Maximum speed in pixels per second
var input_vector: Vector2 = Vector2.ZERO

@export var max_auto_timer: float = 1.0  # Duration for movement or stopping
var auto_timer = max_auto_timer
var current_auto_direction: Vector2 = Vector2.ZERO

var target = null

func _physics_process(delta: float):
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
			else:
				return

func static_movement():
	input_vector = Vector2.ZERO
	velocity = Vector2.ZERO

func auto_movement(dt: float):
	input_vector = process_auto(dt)
	move(input_vector, dt)

func controllable_movement():
	input_vector = process_input()
	move(input_vector)

func target_movement(target_pos):
	input_vector = process_target_position(target_pos)
	move(input_vector)

func move(input_direction: Vector2, delta: float = 1):
	# Gradually adjust velocity based on input and acceleration
	velocity.x = move_toward(velocity.x, max_speed * input_direction.x, accel)
	velocity.y = move_toward(velocity.y, max_speed * input_direction.y, accel)
	
	# Apply velocity with collision handling
	move_and_slide()

func process_input() -> Vector2:
	# Capture player input for movement
	#return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var input_direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	return input_direction.normalized()

func process_auto(delta: float) -> Vector2:
	# Decrease the timer
	auto_timer -= delta
	
	if auto_timer <= 0.0:
			
		# End the stop phase, choose a new direction, and reset the timer
		current_auto_direction = choose_random_direction()
		auto_timer = max_auto_timer

	return current_auto_direction

func choose_random_direction() -> Vector2:
	# Randomly select one of the four cardinal directions
	var ranum = randi() % 8
	match ranum:
		0: return Vector2.LEFT
		1: return Vector2.RIGHT
		2: return Vector2.UP
		3: return Vector2.DOWN
		4: return Vector2.ZERO
		5: return Vector2.ZERO
		6: return Vector2.ZERO
		7: return Vector2.ZERO
	return Vector2.ZERO

func process_target_position(target_pos) -> Vector2:
	var target_vector = (target_pos - global_position).normalized()
	#print(input_vector)
	# Calculate desired position
	#var desired_position = global_position + (target_vector * (speed/10) * delta)
	return target_vector
