extends CanvasLayer

@onready var camera = $SubViewport/House/Camera3D
@onready var texture_rect = $TextureRect
@onready var right = $TextureRect/Right
@onready var left = $TextureRect/Left
var rooms = ["Outside", "Living", "Kitchen", "Bathroom", "Family", "Bedroom"]
var room_ind = 1

@onready var hud = $HUD
var level_phase = ["Flood", "Prep"]
var current_quest : String

@onready var interaction_panel = $InteractionPanel
@onready var item_container = $InteractionPanel/ScrollContainer/ItemContainer

@onready var kit_items = $KitItems
var correct_items: Array

@onready var hazards = $Hazards

@onready var comm_plans = $CommPlans
var correct_chat = [2, 1, 1]
var current_opt = 0


func _ready():
	hud.set_level_name(level_phase)
	
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


func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		if camera.position.x < 0:
			camera.position.x = 1.5
			camera.position.z = 3.1
			camera.rotation = Vector3(0,0,0)
			room_ind = 1
			_show_room(room_ind)
			left.visible = true
		
		elif camera.position.x < 13.5: 
			camera.position.x += 3
			room_ind += 1
			_show_room(room_ind)
			if camera.position.x == 13.5:
				right.visible = false
		
		else: 
			camera.position.x = 13.5
			room_ind = 5
			_show_room(room_ind)
	
	if Input.is_action_just_pressed("ui_left"):
		if camera.position.x <= 1.5:
			camera.position.x = -1.9
			camera.position.z = 1.5
			camera.rotation = Vector3(0,PI/-2,0)
			room_ind = 0
			_show_room(room_ind)
			left.visible = false
		
		else: 
			camera.position.x -= 3
			room_ind -= 1
			_show_room(room_ind)
			right.visible = true


func _show_room(index: int):
	current_quest = interaction_panel.get_current_quest()
	match current_quest:
		"Kit": kit_items.show_room(rooms[index])
		"Hazards": hazards.show_room(rooms[index])


func _on_hud_game_paused(pause_state):
	texture_rect.visible = !pause_state
	interaction_panel.visible = !pause_state


# TODO: handle player_died
func _on_hud_player_died():
	print("Player died")


# TODO: when a quest is completed:
# move current quest to q_list, move next quest as current (in interaction_panel.gd)
# DONE: remove old quest items and add new quest items (in interaction_panel.gd)
# set new quest_scene
# change current_quest
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


# TODO: queue free kititems, mark quest as complete and start hazards
func _kit_items_done():
	pass


func _on_hazards_hazard_managed(hazard: String, status: bool):
	if status:
		hud.update_score(5)
		var node = item_container.get_node(hazard)
		node.item_collected()
		item_container.sort_items()
		interaction_panel.update_current_quest(1)
	else:
		hud.update_score(-2)
		hud.update_life(-1)


# TODO: queue free hazards, mark quest as complete, start commplans
func _hazards_done():
	pass


func _on_comm_plans_keypad_ok(number: String):
	if number.match("999"):
		hud.update_score(10)
		comm_plans.start_family()
	else:
		hud.update_score(-2)
		hud.update_life(-1)


func _on_comm_plans_chat_selected(option: String):
	if option.contains(str(correct_chat[current_opt])):
		hud.update_score(5)
		comm_plans.opt_eval = true
	else:
		comm_plans.opt_eval = false
		hud.update_score(-1)
	
	current_opt += 1


func _comm_plans_done():
	pass
