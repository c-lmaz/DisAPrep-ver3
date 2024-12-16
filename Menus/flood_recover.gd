extends CanvasLayer

signal recover_ends(score: int, quests: Dictionary, time_left: int)

@onready var house = $SubViewport/House
@onready var camera = $SubViewport/House/Camera3D
@onready var texture_rect = $TextureRect
@onready var right = $TextureRect/Right
@onready var left = $TextureRect/Left
var rooms = ["Outside", "Living", "Kitchen", "Bathroom", "Family", "Bedroom"]
var room_ind = 1

@onready var hud = $HUD
var level_phase = ["Flood", "Respond"]
var current_quest : String
var hud_timer = 120

@onready var interaction_panel = $InteractionPanel
@onready var item_container = $InteractionPanel/ScrollContainer/ItemContainer


func _ready():
	hud.set_level_name(level_phase)
	hud.set_timer(hud_timer)
	
	hud.game_paused.connect(_on_hud_game_paused)
	hud.player_died.connect(_on_hud_player_died)
	
	interaction_panel.quest_completed.connect(_on_int_panel_quest_completed)
	
	#for child in item_container.get_children():
		#correct_items.push_back(str(child.name))


func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		if camera.position.x < 0:
			room_ind = 1
			_show_room(room_ind)
			left.visible = true
		
		elif camera.position.x < 13.5:
			room_ind += 1
			_show_room(room_ind)
			if camera.position.x == 13.5:
				right.visible = false
		
		else: 
			room_ind = 5
			_show_room(room_ind)
		
		house.move_right()
	
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


# TODO
func _show_room(index: int):
	current_quest = interaction_panel.get_current_quest()
	#match current_quest:
		#"Kit": kit_items.show_room(rooms[index])
		#"Hazards": hazards.show_room(rooms[index])


func _on_hud_game_paused(pause_state):
	texture_rect.visible = !pause_state
	interaction_panel.visible = !pause_state


# TODO: handle player_died
func _on_hud_player_died():
	print("Player died")
	_level_ends()


# TODO
func _on_int_panel_quest_completed(q_name: String):
	#match q_name:
		#"Kit":
			#_kit_items_done()
			#interaction_panel.set_next_quest()
			#interaction_panel.set_next_quest_items(1)
		#"Hazards":
			#_hazards_done()
			#interaction_panel.set_next_quest()
			#interaction_panel.set_next_quest_items(2)
		#"Comm":
			#_comm_plans_done()
	pass


func _level_ends():
	var rec_quests = interaction_panel.get_quests_progress()
	var rec_time = hud.get_time_left()
	recover_ends.emit(hud.score, rec_quests, rec_time)
	print(rec_quests + " " +  rec_time)
