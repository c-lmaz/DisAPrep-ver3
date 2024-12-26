extends Control

signal items_selected(items: Array, current_spot: String)
signal all_spots_done()

@onready var future_menu = $FutureMenu
@onready var future_menu_question = $FutureMenu/Question
@onready var future_menu_reading = $FutureMenu/Reading

var current_spot : String
var completed_spots = 0

func _ready():
	for control in get_children():
		if control is TextureButton:
			control.connect("pressed", _on_button_pressed.bind(control))


func _on_button_pressed(button):
	current_spot = button.name
	
	var menu = future_menu_reading.get_node(current_spot)
	if menu:
		menu.visible = true
		future_menu.visible = true
		future_menu_reading.visible = true
		button.queue_free()


func _on_next_button_pressed():
	var menu_reading = future_menu_reading.get_node(current_spot)
	if menu_reading:
		menu_reading.visible = false
		future_menu_reading.visible = false
	
	var menu_question = future_menu_question.get_node(current_spot)
	if menu_question:
		menu_question.visible = true
		future_menu_question.visible = true


func _on_submit_button_pressed():
	var node = future_menu_question.get_node(current_spot)
	node = node.get_node("ItemList")
	var selected = []
	for item in node.get_children():
		if item.button_pressed:
			selected.push_back(str(item.name))
	
	# Send answer for validation
	items_selected.emit(selected, current_spot)
	
	future_menu.visible = false
	future_menu_question.visible = false
	node = node.get_parent()
	node.queue_free()
	
	completed_spots += 1
	if completed_spots == 3:
		all_spots_done.emit()
