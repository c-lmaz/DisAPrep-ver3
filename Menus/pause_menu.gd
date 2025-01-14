extends Panel

signal resume_pressed(pause: bool)
signal exit_pressed

@onready var tip = $VBoxContainer/Tip

var tip_path = "res://Data/tip_list.json"
var tip_list

func _ready():
	tip_list = Global.read_json_file("res://Data/tip_list.json")
	tip_list = tip_list["Tips"]


func _on_visibility_changed():
	if is_node_ready():
		tip.text = tip_list.pick_random()


func _on_resume_pressed():
	resume_pressed.emit(false)


func _on_exit_pressed():
	exit_pressed.emit()


func _on_bgm_button_toggled(toggled_on):
	AudioManager.toggle_bgm(!toggled_on)
