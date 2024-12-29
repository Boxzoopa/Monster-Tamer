class_name ButtonComponent extends Button

var selected = false
signal focus_selected

# Called when the button gains focus
func _on_focus_entered() -> void:
	selected = true

# Called when the button loses focus
func _on_focus_exited() -> void:
	selected = false

func check_focus():
	if selected and Input.is_action_pressed("A"):
		Config.debug_msg("A")
		focus_selected.emit()
	

# Override default behavior to use the "A" input
func _physics_process(_delta: float) -> void:
	check_focus()
