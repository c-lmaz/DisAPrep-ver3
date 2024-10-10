extends Control

signal items_collected(items: Array)

@onready var kit_menu = $KitMenu
@onready var kit_menu_cont = $KitMenu/VBoxContainer

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
	for menu in kit_menu_cont.get_children():
		if menu.name == current_spot:
			menu.visible = true
			kit_menu.visible = true
			parent.visible = false


func show_room(room: String):
	for control in get_children():
		if control.name == room:
			control.visible = true
		else:
			control.visible = false


func _on_collect_button_pressed():
	var node = kit_menu_cont.get_node(current_spot)
	var collected = []
	for item in node.get_children():
		if item.button_pressed:
			collected.push_back(str(item.name))
	
	# Send answer for validation
	items_collected.emit(collected)
	
	# Toggle visiblity
	var room = get_node(current_room)
	room.visible = true
	kit_menu.visible = false
	
	# Handle queuefree
	var node_button = room.get_node(current_spot)
	node.queue_free()
	node_button.queue_free()
