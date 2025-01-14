extends CanvasLayer

signal prepare_ends(score: int, quests: Dictionary, time_left: int)

@onready var house = $SubViewport/House
@onready var camera = $SubViewport/House/Camera3D
@onready var texture_rect = $TextureRect
@onready var right = $TextureRect/Right
@onready var left = $TextureRect/Left
var rooms = ["Outside", "Living", "Kitchen", "Bathroom", "Family", "Bedroom"]
var room_ind = 1

@onready var hud = $HUD
var level_phase = ["Flood", "Prepare"]
var current_quest : String
var hud_timer = 180

@onready var interaction_panel = $InteractionPanel
@onready var item_container = $InteractionPanel/ScrollContainer/ItemContainer

@onready var kit_items = $KitItems
var correct_items: Array

@onready var hazards = $Hazards

@onready var comm_plans = $CommPlans
var correct_chat = [2, 1, 1]
var current_opt = 0

@onready var start_panel = $StartPanel
@onready var end_panel = $EndPanel
@onready var hs_label = $StartPanel/MarginContainer/VBoxContainer/HighscoreLabel


func _ready():
	hud.set_level_name(level_phase)
	hud.set_timer(hud_timer)
	
	hud.game_paused.connect(_on_hud_game_paused)
	hud.player_died.connect(_on_hud_player_died)
	
	interaction_panel.quest_completed.connect(_on_int_panel_quest_completed)
	
	kit_items.items_collected.connect(_on_kit_items_collected)
	kit_items.all_spots_done.connect(_kit_items_done)
	
	hazards.hazard_managed.connect(_on_hazards_hazard_managed)
	
	comm_plans.keypad_ok.connect(_on_comm_plans_keypad_ok)
	comm_plans.chat_selected.connect(_on_comm_plans_chat_selected)
	comm_plans.comm_plans_completed.connect(_comm_plans_done)
	
	for child in item_container.get_children():
		correct_items.push_back(str(child.name))
	
	current_quest = interaction_panel.get_current_quest()
	
	var level_hs = Global.read_level_progress()
	level_hs = level_hs["Flood"]["Prepare"]["Highscore"]
	if level_hs:
		hs_label.text = str(level_hs)
	else:
		hs_label.text = "0"


func start_level(): 
	start_panel.visible = false
	hud.start()


func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		if camera.position.x < 0:
			room_ind = 1
			_show_room(room_ind)
			left.visible = true
		
		elif camera.position.x < 13.5:
			room_ind += 1
			_show_room(room_ind)
		
		else: 
			room_ind = 5
			_show_room(room_ind)
		
		house.move_right()
		if camera.position.x == 13.5:
			right.visible = false
	
	if Input.is_action_just_pressed("ui_left"):
		if camera.position.x <= 1.5:
			room_ind = 0
			_show_room(room_ind)
			left.visible = false
		
		else: 
			room_ind -= 1
			_show_room(room_ind)
			right.visible = true
		
		house.move_left()


func _show_room(index: int):
	current_quest = interaction_panel.get_current_quest()
	match current_quest:
		"Kit": kit_items.show_room(rooms[index])
		"Hazards": hazards.show_room(rooms[index])


func _on_hud_game_paused(pause_state):
	current_quest = interaction_panel.get_current_quest()
	match current_quest:
		"Kit":
			kit_items.visible = !pause_state
			texture_rect.visible = !pause_state
		"Hazards":
			hazards.visible = !pause_state
			texture_rect.visible = !pause_state
		"Comm":
			comm_plans.visible = !pause_state
			comm_plans.set_paused(pause_state)
	interaction_panel.visible = !pause_state


func _on_hud_player_died():
	_level_ends()


func _on_int_panel_quest_completed(q_name: String):
	match q_name:
		"Kit":
			_kit_items_done()
		"Hazards":
			_hazards_done()
		"Comm":
			_comm_plans_done()


func _on_kit_items_collected(items: Array):
	for i in items:
		if correct_items.has(i):
			hud.update_score(5)
			var node = item_container.get_node(i)
			node.item_collected()
			item_container.sort_items()
			interaction_panel.update_current_quest(1)
		else:
			hud.update_score(-1)
			hud.update_life(-1)


func _kit_items_done():
	print("kit done")
	kit_items.disconnect("all_spots_done", _kit_items_done)
	camera.position = Vector3(1.5, 0.6, 3.1)
	room_ind = 1
	_show_room(room_ind)
	right.visible = true
	left.visible = true
	hazards.visible = true
	kit_items.visible = false
	kit_items.queue_free()
	interaction_panel.set_next_quest()
	interaction_panel.set_next_quest_items(1)


func _on_hazards_hazard_managed(hazard: String, status: bool):
	if status:
		hud.update_score(5)
		var node = item_container.get_node(hazard)
		node.item_collected()
		item_container.sort_items()
		interaction_panel.update_current_quest(1)
		
		match hazard:
			"Sandbag":
				house.get_node("Outside").visible = false
				house.get_node("OutsideBagged").visible = true
			"Rug":
				var house_nodes = house.get_children(true)
				for hnode in house_nodes:
					if node.name.contains("Carpet"):
						node.visible = false
	
	else:
		hud.update_score(-2)
		hud.update_life(-1)


func _hazards_done():
	print("hazard done")
	comm_plans.visible = true
	hazards.visible = false
	texture_rect.visible = false
	hazards.queue_free()
	interaction_panel.set_next_quest()
	interaction_panel.set_next_quest_items(2)


func _on_comm_plans_keypad_ok(number: String):
	if number.match("999"):
		hud.update_score(10)
		var node = item_container.get_node("Emergency")
		node.item_collected()
		item_container.sort_items()
		interaction_panel.update_current_quest(1)
		comm_plans.start_family()
	else:
		hud.update_score(-2)
		hud.update_life(-1)


func _on_comm_plans_chat_selected(option: String):
	if option.contains(str(correct_chat[current_opt])):
		hud.update_score(5)
		comm_plans.opt_eval = true
		if current_opt == 1:
			var node = item_container.get_node("Family1")
			node.item_collected()
			item_container.sort_items()
			interaction_panel.update_current_quest(1)
		elif current_opt == 2:
			var node = item_container.get_node("Family2")
			node.item_collected()
			item_container.sort_items()
			interaction_panel.update_current_quest(1)
	else:
		comm_plans.opt_eval = false
		hud.update_score(-1)
	
	current_opt += 1


func _comm_plans_done():
	print("comm done")
	await get_tree().create_timer(4.0).timeout
	_level_ends()


func _level_ends():
	var prep_quests = interaction_panel.get_quests_progress()
	var prep_time = hud.get_time_left()
	var prep_score = hud.score + (int(prep_time/10)*5)
	
	var phase_progress = {
			"Score": prep_score,
			"TimeLeft": prep_time,
			"Kit": prep_quests["Kit"],
			"Hazards": prep_quests["Hazards"],
			"Comm": prep_quests["Comm"],
		}
	
	Global.save_level_progress("Flood", "Prepare", phase_progress)
	
	$EndPanel/MarginContainer/VBoxContainer/Score/ScoreLabel.text = str(hud.score)
	$EndPanel/MarginContainer/VBoxContainer/Time/TimeLabel.text = str(prep_time) + " sec"
	$EndPanel/MarginContainer/VBoxContainer/TotalScore/TScoreLabel.text = str(prep_score)
	
	var level_hs = Global.read_level_progress()
	level_hs = level_hs["Flood"]["Prepare"]["Highscore"]
	if level_hs:
		$EndPanel/MarginContainer/VBoxContainer/Highscore/HScoreLabel.text = str(level_hs)
	else:
		$EndPanel/MarginContainer/VBoxContainer/Highscore/HScoreLabel.text = "0"
	end_panel.visible = true


func _on_start_button_pressed():
	start_level()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Menus/level_menu.tscn")

