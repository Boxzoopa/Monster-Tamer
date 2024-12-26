extends Control

@export var action_name: String = "None"
@export var name_visible: bool = true
@onready var action_label: Label = $ActionName

# Define the Xbox controller button indices
var XBOX_BUTTON_TO_INDEX_MAPPING = {
	"A": 0,    # A button
	"B": 1,    # B button
	"X": 2,    # X button
	"Y": 3,    # Y button
	"START": 7, # Start button
	"SELECT": 6 # Select/Back button
}

# Define the keyboard button indices based on the scancodes
const KEYBOARD_BUTTON_TO_INDEX_MAPPING = {
	KEY_A: 65,        # A key
	KEY_B: 66,        # B key
	KEY_C: 67,        # C key
	KEY_D: 68,        # D key
	KEY_E: 69,        # E key
	KEY_F: 70,        # F key
	KEY_G: 71,        # G key
	KEY_H: 72,        # H key
	KEY_I: 73,        # I key
	KEY_J: 74,        # J key
	KEY_K: 75,        # K key
	KEY_L: 76,        # L key
	KEY_M: 77,        # M key
	KEY_N: 78,        # N key
	KEY_O: 79,        # O key
	KEY_P: 80,        # P key
	KEY_Q: 81,        # Q key
	KEY_R: 82,        # R key
	KEY_S: 83,        # S key
	KEY_T: 84,        # T key
	KEY_U: 85,        # U key
	KEY_V: 86,        # V key
	KEY_W: 87,        # W key
	KEY_X: 88,        # X key
	KEY_Y: 89,        # Y key
	KEY_Z: 90,        # Z key
	KEY_ENTER: 16777221, # Enter key
	KEY_SPACE: 32,    # Spacebar
	KEY_ESCAPE: 16777217, # Escape key
}


func _ready() -> void:
	action_label.text = self.action_name

func get_current_icon_index(device_id: int, action_name: String):
	for action in InputMap.has_action(action_name):
		
