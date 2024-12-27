extends Area2D

var player_in_contact = false
@export var dialog: JSON = load("res://resources/dialog/test.json")
@onready var pointer: Sprite2D = $Pointer
@onready var state = {
	"show_only_one": false,
	"player_name": Config.player_name
}

signal dialog_finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func check_dialog():
	if player_in_contact and Input.is_action_just_pressed("ui_accept"):
		return true

func start_dialog(dialog_json: JSON = dialog,  _state : Dictionary = state):
	Config.debug_msg("dialog start")
	Hud.get_node("DialogBox").start_dialog(dialog_json, _state, self)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_contact = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_contact = false
