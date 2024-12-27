extends Control

@export var dialog_json: JSON
@onready var state = {
	"show_only_one": false,
	"player_name": Config.player_name
}

@onready var dialog_label: Label = $VBox/Dialog
@onready var choices: HBoxContainer = $VBox/Choices
@onready var ez_dialogue: EzDialogue = $EzDialogue

@onready var choice_button_scn = preload("res://scenes/components/choice_button_component.tscn")
var choice_btns: Array[Button] = []

@onready var cause_node: Area2D = null

signal dialog_finished
signal _on_monster_tamed

func _ready() -> void:
	self.visible = false

func start_dialog(dialog: JSON = dialog_json, _state : Dictionary = state, cause = null) -> void:
	cause_node = cause
	Config.active = false
	self.visible = true
	ez_dialogue.start_dialogue(dialog, _state)

func clear_dialog_box():
	dialog_label.text = ""
	for choice in choice_btns:
		choices.remove_child(choice)
	choice_btns = []

func add_text(text: String):
	dialog_label.text = text

func add_choice(choice_text: String):
	var button_obj: ChoiceButtonComponent = choice_button_scn.instantiate()
	button_obj.choice_index = choice_btns.size()
	choice_btns.push_back(button_obj)
	button_obj.text = choice_text
	choices.add_child(button_obj)
	button_obj.choice_selected.connect(_on_choice_selected)
	choices.get_child(0).grab_focus()

func _on_choice_selected(choice_index: int):
	Config.debug_msg(str(choice_index))
	ez_dialogue.next(choice_index)
	clear_dialog_box()


func _on_ez_dialogue_dialogue_generated(response: DialogueResponse) -> void:
	add_text(response.text)
	
	if response.choices.is_empty() and response.text.is_empty():
		dialog_finished.emit()
	elif response.choices.is_empty():
		add_choice("...")
	else:
		for choice in response.choices:
			add_choice(choice)


func _on_dialog_finished() -> void:
	self.visible = false
	Config.active = true
	if cause_node != null:
		cause_node.dialog_finished.emit()


func _on_ez_dialogue_custom_signal_received(value: Variant) -> void:
	#var params = value.split(",")
	MD.add_monster(Config.current_monster)
	
	MD.display_party()
