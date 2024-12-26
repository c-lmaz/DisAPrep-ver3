extends Control

signal items_selected(items: Array, current_spot: String)
signal all_spots_done()

@onready var repair_menu = $RepairMenu
@onready var repair_menu_cont = $RepairMenu/VBoxContainer

var current_spot : String
var completed_spots = 0

func _ready():
	for control in get_children():
		if control is TextureButton:
			control.connect("pressed", _on_button_pressed.bind(control))


func _on_button_pressed(button):
	current_spot = button.name
	
	for menu in repair_menu_cont.get_children():
		if menu.name == current_spot:
			menu.visible = true
			repair_menu.visible = true
			button.queue_free()


func _on_submit_button_pressed():
	var node = repair_menu_cont.get_node(current_spot)
	node = node.get_node("ItemList")
	var selected = []
	for item in node.get_children():
		if item.button_pressed:
			selected.push_back(str(item.name))
	
	# Send answer for validation
	items_selected.emit(selected, current_spot)
	
	repair_menu.visible = false
	node = node.get_parent()
	node.queue_free()
	
	completed_spots += 1
	if completed_spots == 5:
		all_spots_done.emit()
