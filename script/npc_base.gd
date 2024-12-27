extends "res://script/character.gd"

var player_in_contact = false
@export var has_dialog = true
@export var dialog: JSON = load("res://resources/dialog/test.json")
@onready var trigger: Area2D = $DialogTriggerComponent

func _physics_process(delta: float) -> void:
	# Add the gravity.
	get_movement_type(delta)
	
	# Check for input if the player is in contact
	if has_dialog:
		if trigger.check_dialog():
			trigger.start_dialog(dialog)
