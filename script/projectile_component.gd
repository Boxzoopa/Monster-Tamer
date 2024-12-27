class_name ProjectileComponent extends "res://script/hitbox_component.gd"

@export var speed: int = 100

enum dirs {
	RIGHT, LEFT, DOWN, UP
}
enum dist {
	NONE, SMALL, MEDIUM
}

@export var distance: dist = dist.NONE
@export var direction: dirs = dirs.RIGHT
var directions = Vector2.RIGHT

func _ready() -> void:
	get_direction()
	
	directions.x = clampi(directions.x, -1, 1)
	directions.y = clampi(directions.y, -1, 1)

func get_direction():
	match direction:
		dirs.RIGHT:
			directions = Vector2.RIGHT
		dirs.LEFT:
			directions = Vector2.LEFT
		dirs.DOWN:
			directions = Vector2.DOWN
		dirs.UP:
			directions = Vector2.UP

func _physics_process(delta: float) -> void:
	var dir = directions.rotated(rotation)
	if distance == dist.NONE:
		global_position += speed * dir * delta

func destroy():
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	destroy()

func _on_body_entered(body: Node2D) -> void:
	destroy()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
