extends Control




func _on_start_level_pressed():
	get_tree().change_scene_to_file("res://Menus/flood_main.tscn")


func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Menus/tutorial_menu.tscn")


func _on_notes_pressed():
	get_tree().change_scene_to_file("res://Menus/notes_menu.tscn")


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Menus/settings_menu.tscn")
