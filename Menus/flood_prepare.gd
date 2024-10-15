extends CanvasLayer

@onready var camera = $SubViewport/House/Camera3D
@onready var texture_rect = $TextureRect
@onready var right = $TextureRect/Right
@onready var left = $TextureRect/Left
var rooms = ["Outside", "Living", "Kitchen", "Bathroom", "Family", "Bedroom"]
var room_ind = 1

@onready var hud = $HUD
var level_phase = ["Flooood", "Prep"]
var current_quest : String

@onready var interaction_panel = $InteractionPanel
@onready var item_container = $InteractionPanel/ScrollContainer/ItemContainer

@onready var kit_items = $KitItems
var correct_items: Array

@onready var hazards = $Hazards

func _ready():
	hud.set_level_name(level_phase)
	
	hud.game_paused.connect(_on_hud_game_paused)
	hud.player_died.connect(_on_hud_player_died)
	
	interaction_panel.quest_completed.connect(_on_int_panel_quest_completed)
	
	kit_items.items_collected.connect(_on_kit_items_collected)
	kit_items.all_spots_done.connect(_kit_items_done)
	
	hazards.hazard_managed.connect(_on_hazards_hazard_managed)
	
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



# TODO: handle these situations
# DONE: all items collected
# DONE: all spots done
# timeout
# life empty
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
	pass


# TODO: validate answers
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


func _hazards_done():
	pass
