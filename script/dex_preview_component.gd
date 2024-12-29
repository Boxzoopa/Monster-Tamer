extends VBoxContainer

@export var data :MonsterData

@onready var mon_name: Label = $MonName
@onready var mon_texture: TextureRect = $MonTexture
@onready var mon_type_label: Label = $MonType/MonTypeLabel
@onready var mon_desc: Label = $MonInfo/MonDesc

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if data == null:
		Config.debug_msg("No Monster Data")
		mon_name.text = "???"
		mon_desc.text = "No Description Available"
		mon_type_label.text = "???"
	else:
		load_data()
	

func load_data():
	data.set_seen_and_tamed()
	mon_name.text = data.name
	mon_texture.texture = data.sprite
	mon_type_label.text = Config.TypeNames[data.type1]
	mon_desc.text = "Type: " + data.entry 
	if data.type2 != data.type1:
		mon_type_label.text = "Type: " + Config.TypeNames[data.type1] + "/" + Config.TypeNames[data.type2]
	
	Config.debug_msg(str("monster " + data.name +" registered"))
