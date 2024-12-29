extends VBoxContainer

@export var data :MonsterData
@export var standalone: bool = true

@onready var mon_name: Label = $MonName
@onready var mon_texture: TextureRect = $MonTexture
@onready var mon_type_label: Label = $MonType/MonTypeLabel
@onready var mon_desc: Label = $MonInfo/MonDesc

@onready var close_info: Label = $CloseInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !standalone:
		close_info.hide()
	
	if data == null:
		Config.debug_msg("No Monster Data")
		mon_name.text = "???"
		mon_desc.text = "No Description Available"
		mon_type_label.text = "???"
	else:
		load_data()
	

func load_data(dat: MonsterData = data):
	dat.set_seen_and_tamed()
	mon_name.text = dat.name
	mon_texture.texture = dat.sprite
	mon_type_label.text = Config.TypeNames[dat.type1]
	mon_desc.text = "Type: " + dat.entry 
	if dat.type2 != dat.type1:
		mon_type_label.text = "Type: " + Config.TypeNames[dat.type1] + "/" + Config.TypeNames[dat.type2]
	
	Config.debug_msg(str("monster " + dat.name +" registered"))


func _process(delta: float) -> void:
	if standalone:
		if Input.is_action_just_pressed("B"):
			close_entry()


func show_entry():
	show()
	Config.active = false

func close_entry():
	hide()
	Config.debug_msg("Closing dex, press enter to view")
	Config.active = true
