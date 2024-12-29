extends Control

@onready var hp = $"Panel/Player Stats/HP/Label"
@onready var coins = $"Panel/Player Stats/Coins/Label"
@onready var bait = $"Panel/Player Stats/Bait/Label"

@onready var dex: Control = $Dex

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hp.text = str(Config.player_hp)
	
	if not Config.player_in_dialog:
		if Input.is_action_pressed("start"):
			Config.active = false
			show_dex(true)
			dex.get_focus()
		if Input.is_action_pressed("B"):
			Config.active = true
			show_dex(false)


func show_dex(show: bool):
	dex.visible = show
