extends Button
class_name ChoiceButtonComponent

@onready var choice_index

signal choice_selected(choice_index)


func _on_pressed() -> void:
	choice_selected.emit(choice_index)
