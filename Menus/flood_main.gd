extends Control

@onready var flood_prepare = preload("res://Menus/flood_prepare.tscn")
@onready var flood_respond = preload("res://Menus/flood_respond.tscn")
@onready var flood_recover = preload("res://Menus/flood_recover.tscn")
@onready var level_start_menu = $LevelStartMenu
@onready var level_end_menu = $LevelEndMenu

@onready var phase_start = $LevelStartMenu/VBoxContainer/Phase
@onready var quest_list = $LevelStartMenu/VBoxContainer/QuestList
@onready var level = $LevelEndMenu/VBoxContainer/Level
@onready var phase_end = $LevelEndMenu/VBoxContainer/Phase
@onready var score_val = $LevelEndMenu/VBoxContainer/HBoxContainer/ScoreVal
@onready var total_score = $LevelEndMenu/VBoxContainer/HBoxContainer2/TotalScore

var font = "res://Themes/Fonts/InriaSans-Regular.otf"
var all_quests = Global.read_json_file("res://Data/Flood/quests.json")
var curr_quests
enum Phases{PREPARE, RESPOND, RECOVER}
var curr_phase = Phases.PREPARE
var t_score = 0
var phase

func _ready():
	curr_quests = all_quests["Prepare"]
	_manage_quest_list(curr_quests)


func _manage_quest_list(phase_q: Array):
	match curr_phase:
		Phases.PREPARE: 
			phase_start.text = "PREPARE"
			phase_end.text = "PREPARE"
		Phases.RESPOND:
			phase_start.text = "RESPOND"
			phase_end.text = "RESPOND"
		Phases.RECOVER:
			phase_start.text = "RECOVER"
			phase_end.text = "RECOVER"
	
	for i in range(phase_q.size()):
		var child = Label.new()
		child.text = curr_quests[i]["name"]
		child.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		child.autowrap_mode = TextServer.AUTOWRAP_WORD
		child.custom_minimum_size.x = 400
		child.add_theme_color_override("font_color", Color(0.78, 0.78, 0.78))
		child.add_theme_font_override("font", load(font))
		child.add_theme_font_size_override("font_size", 28)
		quest_list.add_child(child)
		
		var progress = Label.new()
		progress.text = str(curr_quests[i]["total"])
		progress.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		progress.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		progress.add_theme_color_override("font_color", Color(0.78, 0.78, 0.78))
		progress.add_theme_font_override("font", load(font))
		progress.add_theme_font_size_override("font_size", 28)
		quest_list.add_child(progress)


func _on_prepare_phase_ends(score: int, quests: Dictionary, time: int):
	var phase_progress = {
			"Score": score,
			"TimeLeft": time,
			"Kit": quests["Kit"],
			"Hazards": quests["Hazards"],
			"Comm": quests["Comm"],
		}
	
	Global.save_level_progress("Flood", "Prepare", phase_progress)
	_display_score(score)
	phase.visible = false
	phase.queue_free()
	for child in quest_list.get_children():
		child.queue_free()


func _on_respond_phase_ends(score: int, time: int):
	var phase_progress = {
			"Score": score,
			"TimeLeft": time,
			"Evac": 1 if score > 0 else 0,
		}
	
	Global.save_level_progress("Flood", "Respond", phase_progress)
	_display_score(score)
	phase.visible = false
	phase.queue_free()
	for child in quest_list.get_children():
		child.queue_free()


func _on_recover_phase_ends(score: int, quests: Dictionary, time: int):
	var phase_progress = {
			"Score": score,
			"TimeLeft": time,
			"Kit": quests["Kit"],
			"Hazards": quests["Hazards"],
			"Comm": quests["Comm"],
		}
	
	Global.save_level_progress("Flood", "Recover", phase_progress)
	_display_score(score)
	phase.visible = false
	phase.queue_free()
	for child in quest_list.get_children():
		child.queue_free()


func _on_start_pressed():
	level_start_menu.visible = false
	
	match curr_phase:
		Phases.PREPARE:
			phase = flood_prepare.instantiate()
			add_child(phase)
			phase.prepare_ends.connect(_on_prepare_phase_ends)
		Phases.RESPOND:
			phase = flood_respond.instantiate()
			add_child(phase)
			phase.respond_ends.connect(_on_respond_phase_ends)
		Phases.RECOVER:
			phase = flood_recover.instantiate()
			add_child(phase)
			phase.recover_ends.connect(_on_recover_phase_ends)
			$LevelEndMenu/VBoxContainer/Button.text = "Go to Home"
	
	phase.visible = true
	phase.start_level()


func _on_next_pressed():
	match curr_phase:
		Phases.PREPARE:
			curr_phase = Phases.RESPOND
			curr_quests = all_quests["Respond"]
		Phases.RESPOND:
			curr_phase = Phases.RECOVER
			curr_quests = all_quests["Recover"]
		Phases.RECOVER:
			get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
	
	_manage_quest_list(curr_quests)
	level_end_menu.visible = false
	level_start_menu.visible = true


func _display_score(score: int):
	t_score += score
	total_score.text = str(t_score)
	score_val.text = str(score)
	level_end_menu.visible = true
