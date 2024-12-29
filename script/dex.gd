extends Control

@onready var monlist_box: VBoxContainer = $MainContainer/HBox/MonList/VBox
const button_scn = preload("res://scenes/components/dex_button_component.tscn")
@onready var v_box: VBoxContainer = $MainContainer/HBox/MonList/VBox
var btns: Array[Button] = []

@onready var mon_prev_no_data: CompressedTexture2D = load("res://assets/monsters/battle/mon_0.png")

@onready var mon_prev: VBoxContainer = $MainContainer/HBox/MonPrev #monster preview
@onready var mon_name: Label = $MainContainer/HBox/MonPrev/MonName
@onready var mon_texture: TextureRect = $MainContainer/HBox/MonPrev/MonTexture
@onready var mon_info: Panel = $MainContainer/HBox/MonPrev/MonInfo
@onready var mon_desc: Label = $MainContainer/HBox/MonPrev/MonInfo/MonDesc
@onready var mon_type_label: Label = $MainContainer/HBox/MonPrev/MonType/MonTypeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_monsters()

func _process(delta: float) -> void:
	for btn in btns:
		if btn.selected:
			if btn.monster.seen:
				mon_texture.texture = btn.monster.sprite
				mon_name.text = btn.monster.name
				mon_type_label.text = "Type: " + Config.TypeNames[btn.monster.type1]
				if btn.monster.type2 != btn.monster.type1:
					mon_type_label.text = "Type: " + Config.TypeNames[btn.monster.type1] + "/" + Config.TypeNames[btn.monster.type2]
				if btn.monster.tamed: mon_desc.text = btn.monster.entry
			else:
				mon_texture.texture = mon_prev_no_data
				mon_name.text = "???"
				mon_desc.text = "No Description Available"
				mon_type_label.text = "???"

func get_focus():
	v_box.get_child(0).grab_focus()

func load_monsters():
	for monster in MD.monsters:
		if monster.name != "???":
			var button_obj: DexButton = button_scn.instantiate()
			if monster.seen:
				button_obj.text = monster.name
			else:
				button_obj.text = "???"
			button_obj.monster = monster
			btns.push_back(button_obj)
			v_box.add_child(button_obj)
			get_focus()
