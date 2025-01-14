extends Panel




func _on_play_prepare_pressed():
	get_tree().change_scene_to_file("res://Menus/flood_prepare.tscn")


func _on_play_respond_pressed():
	get_tree().change_scene_to_file("res://Menus/flood_respond.tscn")


func _on_play_recover_pressed():
	get_tree().change_scene_to_file("res://Menus/flood_recover.tscn")


func _on_prepare_button_toggled(toggled_on):
	$ScrollContainer/VBoxContainer/FloodLevels/Prepare.visible = toggled_on


func _on_respond_button_toggled(toggled_on):
	$ScrollContainer/VBoxContainer/FloodLevels/Respond.visible = toggled_on


func _on_recover_button_toggled(toggled_on):
	$ScrollContainer/VBoxContainer/FloodLevels/Recover.visible = toggled_on
