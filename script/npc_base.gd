extends "res://script/character.gd"

var player_in_contact = false
@export var dialog: JSON = load("res://resources/dialog/test.json")
@onready var pointer: Sprite2D = $pointer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	auto_movement(delta)

	# Check for input if the player is in contact
	if player_in_contact and Input.is_action_just_pressed("ui_accept"):
		Config.debug_msg("dialog start")
		Hud.get_node("DialogBox").start_dialog()
	
	pointer.visible = player_in_contact

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Config.debug_msg("Player in contact with NPC")
		player_in_contact = true

func _on_hurt_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Config.debug_msg("Player left NPC contact")
		player_in_contact = false
