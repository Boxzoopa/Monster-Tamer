class_name DexButton extends Button

var selected = false
var monster: MonsterData = load("res://resources/monsters/mon_0.tres")

func _on_focus_entered() -> void:
	selected = true


func _on_focus_exited() -> void:
	selected = false
