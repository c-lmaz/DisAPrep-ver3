extends HBoxContainer

var heart_full = preload("res://Icons/Controls/heartFull.png")
var heart_empty = preload("res://Icons/Controls/heartEmpty.png")
var heart_half = preload("res://Icons/Controls/heartHalf.png")


func update_hearts(value):
	for i in get_child_count():
		if value > i*2+1:
			get_child(i).texture = heart_full
		elif value > i*2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty
