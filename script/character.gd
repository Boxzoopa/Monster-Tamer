extends CharacterBody2D

enum Type { STATIC, AUTO, CONTROLLABLE, TARGET }

@export var movement_type: Type = Type.STATIC
@export var accel: float = 10  # Acceleration in pixels per second squared
@export var max_speed: float = 100  # Maximum speed in pixels per second
var input_vector: Vector2 = Vector2.ZERO

func _physics_process(delta: float):
	match movement_type:
		Type.STATIC:
			input_vector = Vector2.ZERO
			velocity = Vector2.ZERO
		Type.AUTO:
			input_vector = Vector2.RIGHT  # Example auto movement; adjust as needed
			move()
		Type.CONTROLLABLE:
			input_vector = process_input()
			move()

func move():
	# Gradually adjust velocity based on input and acceleration
	velocity.x = move_toward(velocity.x, max_speed * input_vector.x, accel)
	velocity.y = move_toward(velocity.y, max_speed * input_vector.y, accel)
	
	# Apply velocity with collision handling
	move_and_slide()

func process_input() -> Vector2:
	# Capture player input for movement
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
