class_name MenuComponent extends VBoxContainer

signal actioned(item: Control)

@export var pointer: Node

func _ready() -> void:
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	config_focus()
	

func _unhandled_input(event: InputEvent) -> void:
	if not visible: return
	
	get_viewport().set_input_as_handled()
	
	var item = get_focused_item()
	if is_instance_valid(item) and event.is_action_pressed("ui_accept"):
		actioned.emit(item)

func get_items() -> Array[Control]:
	var items: Array[Control] = []
	for child in get_children():
		if not child is Control: continue
		if "Heading" in child.name: continue
		if "Divider" in child.name: continue
		items.append(child)
	
	return items

func config_focus():
	var items = get_items()
	
	for i in items.size():
		var item: Control = items[i]
		
		item.focus_mode = Control.FOCUS_ALL
		
		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()
		
		if i == 0:
			item.focus_neighbor_top = item.get_path()
			item.focus_previous = item.get_path()
			item.grab_focus()
		else:
			item.focus_neighbor_top = items[i-1].get_path()
			item.focus_previous = items[i-1].get_path()
		
		if i == items.size() - 1:
			item.focus_neighbor_bottom = item.get_path()
			item.focus_next = item.get_path()
		else:
			item.focus_neighbor_bottom = items[i+1].get_path()
			item.focus_next = items[i+1].get_path()

func get_focused_item():
	var item = get_viewport().gui_get_focus_owner()
	return item if item in get_children() else null

func update_selection():
	var item = get_focused_item()
	
	if is_instance_valid(item) and is_instance_valid(pointer) and visible:
		pointer.global_position = Vector2(global_position.x - 12, item.global_position.y + item.size.y * 0.5)

func _on_focus_changed(item: Control):
	if not item: return
	if not item in get_children(): return
	
	update_selection()


func _on_actioned(item: Control) -> void:
	item.choice_selected.emit(item.choice_index)
