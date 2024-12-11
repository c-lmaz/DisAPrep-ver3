@tool
extends PanelContainer

signal pressed

@export_multiline var button_text: String

@onready var label = $Label
@onready var button = $Button


func _ready():
	update()


func update():
	if button_text:
		label.text = button_text


func _on_button_pressed():
	emit_signal("pressed")
