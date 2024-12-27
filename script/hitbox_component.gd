class_name HitboxComponent extends Area2D

@export var damage: int = 3
@onready var shape: CollisionShape2D = $CollisionShape2D
@export var disabled: bool= false

func _ready() -> void:
	shape.disabled = disabled

func _process(delta: float) -> void:
	shape.disabled = disabled
	
