@tool
class_name ChatOption
extends VBoxContainer

signal chat_selected(option: int, text: String)

@export_multiline var chat_option_1 : String
@export_multiline var chat_option_2 : String
@export_multiline var chat_option_3 : String

@onready var h_box_container = $HBoxContainer
@onready var opt_1 = $"HBoxContainer/1"
@onready var opt_2 = $"HBoxContainer/2"
@onready var opt_3 = $"HBoxContainer/3"


func _ready():
	_update()
	
	for opt in h_box_container.get_children():
		opt.connect("pressed", _on_opt_pressed.bind(opt.name))


func _update():
	opt_1.button_text = chat_option_1
	opt_2.button_text = chat_option_2
	if chat_option_3.is_empty(): opt_3.queue_free()
	else: opt_3.button_text = chat_option_3
	
	for option in h_box_container.get_children():
		option.update()


func _on_opt_pressed(opt_name: String):
	var text
	if opt_name.contains("1"): text = chat_option_1
	elif opt_name.contains("2"): text = chat_option_2
	elif opt_name.contains("3"): text = chat_option_3
	
	chat_selected.emit(opt_name, text)
