@tool
extends Button

@export var normal_tex : CompressedTexture2D 
@export var pressed_tex : CompressedTexture2D
@export var toggled_tex : CompressedTexture2D

@onready var texture = $Texture


func _ready():
	texture.texture = normal_tex


func _on_pressed():
	if !toggle_mode:
		texture.texture = pressed_tex
		await get_tree().create_timer(0.2).timeout
		texture.texture = normal_tex


func _on_toggled(toggled_on):
	if toggled_on:
		texture.texture = toggled_tex
	else:
		texture.texture = normal_tex
