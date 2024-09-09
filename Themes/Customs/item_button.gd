@tool
extends Button

@export var item_name : String :
	set(name):
		if item_name == name:
			return
		item_name = name
		if is_node_ready():
			update()

@export var item_icon : CompressedTexture2D :
	set(icon):
		if item_icon == icon:
			return
		item_icon = icon
		if is_node_ready():
			update()

@onready var panel = $NinePatchRect
@onready var tex_rect = $TextureRect
@onready var label = $Label

var pressed_tex = preload("res://Icons/Controls/shadedLight_EmptyInverse.png")


func _ready():
	update()


func update():
	label.text = item_name
	tex_rect.texture = item_icon
	tex_rect.self_modulate = Color(0.2196, 0.2196, 0.2196, 1)
	name = item_name


func item_collected():
	set_pressed_no_signal(true)
	panel.texture = pressed_tex
	panel.self_modulate = Color(0, 0, 0, 0.3922)
	label.text = "[s]" + item_name + "[/s]"
	tex_rect.self_modulate = Color(1, 1, 1, 0.5882)
