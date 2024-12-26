extends Control

signal items_selected(items: Array, current_spot: String)
signal all_spots_done()

@onready var health_menu = $HealthMenu
@onready var health_menu_cont = $HealthMenu/VBoxContainer

var current_spot : String
var completed_spots = 0

func _ready():
	for control in get_children():
		if control is TextureButton:
			control.connect("pressed", _on_button_pressed.bind(control))


func _on_button_pressed(button):
	current_spot = button.name
	
	match current_spot:
		"Wound": get_node("Sanitise").visible = true
		"Infection": get_node("Treatment").visible = true
	
	var menu = health_menu_cont.get_node(current_spot)
	if menu:
		menu.visible = true
		health_menu.visible = true
		button.queue_free()


func _on_submit_button_pressed():
	var node = health_menu_cont.get_node(current_spot)
	node = node.get_node("ItemList")
	var selected = []
	for item in node.get_children():
		if item.button_pressed:
			selected.push_back(str(item.name))
	
	# Send answer for validation
	items_selected.emit(selected, current_spot)
	
	health_menu.visible = false
	node = node.get_parent()
	node.queue_free()
	
	completed_spots += 1
	if completed_spots == 5:
		all_spots_done.emit()
