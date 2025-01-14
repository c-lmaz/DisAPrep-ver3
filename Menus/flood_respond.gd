extends CanvasLayer

signal respond_ends(score: int, time_left: int)

@onready var maze = $SubViewport/maze
@onready var buttons = $TextureRect

@onready var interaction_panel = $InteractionPanel

@onready var hud = $HUD
var level_phase = ["Flood", "Respond"]
var hud_timer = 60

@onready var start_panel = $StartPanel
@onready var end_panel = $EndPanel
@onready var hs_label = $StartPanel/MarginContainer/VBoxContainer/HighscoreLabel

var all_paths : Array
var next_path : String
var last_life_lost_time = 60
var level_start = false

func _ready():
	hud.set_level_name(level_phase)
	hud.set_timer(hud_timer)
	
	hud.game_paused.connect(_on_hud_game_paused)
	hud.player_died.connect(_on_hud_player_died)
	
	maze.path_ended.connect(_on_maze_path_ended)
	
	for path in $SubViewport/maze/Paths.get_children():
		all_paths.append(path.name)
	
	for button in buttons.get_children():
		button.connect("pressed", _on_direction_pressed.bind(button.name))
	
	var level_hs = Global.read_level_progress()
	level_hs = level_hs["Flood"]["Respond"]["Highscore"]
	if level_hs:
		hs_label.text = str(level_hs)
	else:
		hs_label.text = "0"


func _process(_delta):
	var time_left = hud.get_time_left()
	
	# Lose life every 10 seconds
	if level_start and time_left % 10 == 0 and time_left != last_life_lost_time: 
		hud.update_life(-1)
		last_life_lost_time = time_left


func _on_hud_game_paused(pause_state):
	buttons.visible = !pause_state
	interaction_panel.visible = !pause_state


func start_level(): 
	start_panel.visible = false
	hud.start()
	maze.level_start()


func _on_hud_player_died():
	print("Player died")
	_level_ends()


func _on_maze_path_ended(pathname: String):
	var strings = pathname.split("_")
	next_path = strings[-1]
	
	if next_path.match("Start"): maze.change_path(all_paths[0])
	
	elif next_path.match("DEAD"):
		await get_tree().create_timer(2.0).timeout
		maze.change_path("DEAD")
	
	elif next_path.match("GOAL"):
		interaction_panel.update_current_quest(1)
		hud.update_score(50)
		_level_ends()
	
	else:
		var next_directions : Array
		
		for path in all_paths:
			var path_details = path.split("_")
			if path_details[0].match(next_path):
				next_directions.append(path_details[1])
		
		for button in buttons.get_children():
			if next_directions.has(button.name):
				button.visible = true
			if button.name.match("DEAD"):
				button.visible = true


func _on_direction_pressed(button_name: String):
	if button_name.match("DEAD"):
		maze.change_path("DEAD")
	
	else:
		var chosen_path = next_path + "_" + button_name
		
		for path in all_paths:
			if path.begins_with(chosen_path):
				maze.change_path(path)
	
	for button in buttons.get_children():
		button.visible = false


func _on_int_panel_quest_completed(_q_name): 
	hud.update_score(50)
	_level_ends()


func _level_ends():
	var resp_time = hud.get_time_left()
	var resp_score = hud.score + (int(resp_time/10)*5)
	var phase_progress = {
			"Score": resp_score,
			"TimeLeft": resp_time,
			"Evac": 1 if hud.score > 0 else 0,
		}
	
	Global.save_level_progress("Flood", "Respond", phase_progress)
	
	$EndPanel/MarginContainer/VBoxContainer/Score/ScoreLabel.text = str(hud.score)
	$EndPanel/MarginContainer/VBoxContainer/Time/TimeLabel.text = str(resp_time) + " sec"
	$EndPanel/MarginContainer/VBoxContainer/TotalScore/TScoreLabel.text = str(resp_score)
	
	var level_hs = Global.read_level_progress()
	level_hs = level_hs["Flood"]["Respond"]["Highscore"]
	if level_hs:
		$EndPanel/MarginContainer/VBoxContainer/Highscore/HScoreLabel.text = str(level_hs)
	else:
		$EndPanel/MarginContainer/VBoxContainer/Highscore/HScoreLabel.text = "0"
	end_panel.visible = true


func _on_start_button_pressed():
	start_level()


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Menus/level_menu.tscn")
