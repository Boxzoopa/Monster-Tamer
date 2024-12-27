extends Control

@onready var hp = $"Panel/Player Stats/HP/Label"
@onready var coins = $"Panel/Player Stats/Coins/Label"
@onready var bait = $"Panel/Player Stats/Bait/Label"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hp.text = str(Config.player_hp)
