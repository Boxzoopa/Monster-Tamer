extends ButtonComponent
class_name ChoiceButtonComponent

@onready var choice_index

signal choice_selected(choice_index)


func _on_pressed() -> void:
	choice_selected.emit(choice_index)
	Config.debug_msg("enter")

func _process(delta: float) -> void:
	check_focus()


func _on_focus_selected() -> void:
	choice_selected.emit(choice_index)
	pass # Replace with function body.
