extends NinePatchRect
class_name QuestDisplay

signal quest_completed(q_name: String)

@export var quest : String :
	set(q_name):
		if quest == q_name:
			return
		quest = q_name
		if is_node_ready():
			update()

@export var short_name : String :
	set(s_name):
		if short_name == s_name:
			return
		short_name = s_name
		if is_node_ready():
			update()

@export var q_total : int :
	set(total):
		if q_total == total:
			return
		q_total = total
		if is_node_ready():
			update()

@export var tint_gradient : Gradient
@export var current : bool 

@onready var quest_label = $QuestLabel
@onready var quest_progress = $QuestProgress
@onready var checkmark = $Checkmark

var complete_tex = preload("res://Icons/Controls/shadedLight_Check.png")
var curr_val = 0

func _ready():
	update()

func update():
	name = short_name
	quest_label.text = quest
	quest_progress.max_value = q_total
	quest_progress.value = curr_val
		
	if current:
		quest_progress.visible = true
		checkmark.visible = false
	else:
		quest_progress.visible = false
		checkmark.visible = true


func update_progress(add_value):
	curr_val += add_value
	quest_progress.value = curr_val
	var tint_sample = curr_val/quest_progress.max_value
	quest_progress.self_modulate = tint_gradient.sample(tint_sample)
	
	if curr_val == q_total:
		checkmark.texture = complete_tex
		quest_completed.emit(name)
