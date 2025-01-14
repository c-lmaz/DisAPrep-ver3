extends Node

@onready var bgm = $BGM


func toggle_bgm(toggle: bool):
	if toggle:
		bgm.play()
	else:
		bgm.stop()
