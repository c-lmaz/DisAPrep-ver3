extends Control

signal hazard_managed(item: String, choice: bool)

@onready var hazard_menu = $HazardMenu
@onready var hazard_menu_cont = $HazardMenu/VBoxContainer

var current_room : String
var current_spot : String


func _ready():
	for control in get_children():
		for button in control.get_children():
			if button is TextureButton:
				button.connect("pressed", _on_button_pressed.bind(button, control))


func _on_button_pressed(button, parent):
	current_spot = button.name
	current_room = parent.name
	for menu in hazard_menu_cont.get_children():
		if menu.name == current_spot:
			menu.visible = true
			hazard_menu.visible = true
			parent.visible = false


func show_room(room: String):
	for control in get_children():
		if control.name == room:
			control.visible = true
		else:
			control.visible = false


func _on_yes_button_pressed():
	hazard_managed.emit(current_spot, true)
	
	var room = get_node(current_room)
	room.visible = true
	hazard_menu.visible = false
	
	var node_button = room.get_node(current_spot)
	var node = hazard_menu_cont.get_node(current_spot)
	node.queue_free()
	node_button.queue_free()


func _on_no_button_pressed():
	hazard_managed.emit(current_spot, false)
	
	var room = get_node(current_room)
	room.visible = true
	hazard_menu.visible = false
	
	var node_button = room.get_node(current_spot)
	var node = hazard_menu_cont.get_node(current_spot)
	node.queue_free()
	node_button.queue_free()
