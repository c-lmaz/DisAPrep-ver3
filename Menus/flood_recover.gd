extends CanvasLayer

signal recover_ends(score: int, quests: Dictionary, time_left: int)

@onready var character = $SubViewport/Character
@onready var texture_rect = $TextureRect

@onready var hud = $HUD
var level_phase = ["Flood", "Recover"]
var current_quest : String
var hud_timer = 180

@onready var interaction_panel = $InteractionPanel
@onready var item_container = $InteractionPanel/ScrollContainer/ItemContainer

@onready var health = $Health
var health_correct = Global.read_json_file("res://Data/Flood/rec_items.json")["correct"]["health"]

@onready var repair = $Repair
var repair_correct = Global.read_json_file("res://Data/Flood/rec_items.json")["correct"]["repair"]

@onready var future = $Future
var future_correct = Global.read_json_file("res://Data/Flood/rec_items.json")["correct"]["future"]

@onready var start_panel = $StartPanel
@onready var end_panel = $EndPanel
@onready var hs_label = $StartPanel/MarginContainer/VBoxContainer/HighscoreLabel


func _ready():
	hud.set_level_name(level_phase)
	hud.set_timer(hud_timer)
	
	hud.game_paused.connect(_on_hud_game_paused)
	hud.player_died.connect(_on_hud_player_died)
	
	health.items_selected.connect(_on_health_items_selected)
	health.all_spots_done.connect(_on_health_done)
	
	repair.items_selected.connect(_on_repair_items_selected)
	repair.all_spots_done.connect(_on_repair_done)
	
	future.items_selected.connect(_on_future_items_selected)
	future.all_spots_done.connect(_on_future_done)
	
	var level_hs = Global.read_level_progress()
	level_hs = level_hs["Flood"]["RecoverHighscore"]
	if level_hs:
		hs_label.text = str(level_hs)
	else:
		hs_label.text = "0"


func _on_hud_game_paused(pause_state):
	texture_rect.visible = !pause_state
	interaction_panel.visible = !pause_state
	health.visible = !pause_state
	repair.visible = !pause_state
	future.visible = !pause_state


func start_level(): 
	start_panel.visible = false
	hud.start()


func _on_hud_player_died():
	_level_ends()


func _on_health_items_selected(items: Array, spot: String):
	for i in items:
		if health_correct.has(i):
			hud.update_score(5)
			var node = item_container.get_node(spot)
			node.item_collected()
			item_container.sort_items()
		else:
			hud.update_score(-1)
			hud.update_life(-1)
	
	interaction_panel.update_current_quest(1)


func _on_health_done():
	print("health done")
	health.visible = false
	repair.visible = true
	health.queue_free()
	interaction_panel.set_next_quest()
	interaction_panel.set_next_quest_items(1)


func _on_repair_items_selected(items: Array, spot: String):
	for i in items:
		if repair_correct.has(i):
			hud.update_score(5)
			var node = item_container.get_node(spot)
			node.item_collected()
			item_container.sort_items()
		else:
			hud.update_score(-1)
			hud.update_life(-1)
	
	interaction_panel.update_current_quest(1)


func _on_repair_done():
	print("repair done")
	repair.visible = false
	future.visible = true
	repair.queue_free()
	interaction_panel.set_next_quest()
	interaction_panel.set_next_quest_items(2)


func _on_future_items_selected(items: Array, spot: String):
	for i in items:
		if future_correct.has(i):
			hud.update_score(5)
			var node = item_container.get_node(spot)
			node.item_collected()
			item_container.sort_items()
		else:
			hud.update_score(-1)
			hud.update_life(-1)
	
	interaction_panel.update_current_quest(1)


func _on_future_done():
	print("future done")
	future.visible = false
	future.queue_free()
	_level_ends()


func _level_ends():
	var rec_time = hud.get_time_left()
	var rec_score = hud.score + (int(rec_time/10)*5)
	
	Global.save_level_progress("Flood", "Recover", rec_score)
	Global.save_to_cloud()
	
	$EndPanel/MarginContainer/VBoxContainer/Score/ScoreLabel.text = str(hud.score)
	$EndPanel/MarginContainer/VBoxContainer/Time/TimeLabel.text = str(rec_time) + " sec"
	$EndPanel/MarginContainer/VBoxContainer/TotalScore/TScoreLabel.text = str(rec_score)
	
	var level_hs = Global.read_level_progress()
	level_hs = level_hs["Flood"]["RecoverHighscore"]
	$EndPanel/MarginContainer/VBoxContainer/Highscore/HScoreLabel.text = str(level_hs)
	end_panel.visible = true


func _on_start_button_pressed():
	start_level()


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Menus/level_menu.tscn")
