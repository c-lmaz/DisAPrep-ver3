extends Panel

signal resume_pressed(pause: bool)
signal exit_pressed

@onready var tip = $VBoxContainer/Tip

@onready var sfx_icon = $VBoxContainer/SFX/SFXIcon
@onready var sfx_slider = $VBoxContainer/SFX/SFXSlider
@onready var bgm_icon = $VBoxContainer/BGM/BGMIcon
@onready var bgm_slider = $VBoxContainer/BGM/BGMSlider

var tip_path = "res://Data/tip_list.json"
var tip_list = Global.read_json_file(tip_path)

# TODO: everytime menu becomes visible, change tip
func _on_visibility_changed():
	pass # Replace with function body.


func _on_resume_pressed():
	resume_pressed.emit(false)


func _on_exit_pressed():
	exit_pressed.emit()
