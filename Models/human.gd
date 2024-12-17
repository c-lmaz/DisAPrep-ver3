extends Node3D

signal correct_answer
signal wrong_answer

@onready var animation_tree = $AnimationTree


func _ready():
	connect("correct_answer", _on_correct_answer)
	connect("wrong_answer", _on_wrong_answer)


func _on_correct_answer():
	animation_tree.set("parameters/Correct/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func _on_wrong_answer():
	animation_tree.set("parameters/Wrong/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
