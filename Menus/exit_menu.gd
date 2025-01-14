extends Panel

signal resume_level()

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Menus/level_menu.tscn")


func _on_resume_pressed():
	emit_signal("resume_level")
