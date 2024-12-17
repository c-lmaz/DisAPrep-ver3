extends CanvasLayer

signal recover_ends(score: int, quests: Dictionary, time_left: int)

@onready var character = $SubViewport/Character
@onready var texture_rect = $TextureRect

@onready var hud = $HUD
var level_phase = ["Flood", "Recover"]
var current_quest : String
var hud_timer = 120

@onready var interaction_panel = $InteractionPanel
@onready var item_container = $InteractionPanel/ScrollContainer/ItemContainer

@onready var health = $Health
var health_correct = Global.read_json_file("res://Data/Flood/rec_items.json")["correct"]["health"]


func _ready():
	hud.set_level_name(level_phase)
	hud.set_timer(hud_timer)
	
	hud.game_paused.connect(_on_hud_game_paused)
	hud.player_died.connect(_on_hud_player_died)
	
	health.items_selected.connect(_on_health_items_selected)
	
	interaction_panel.quest_completed.connect(_on_int_panel_quest_completed)


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



func _level_ends():
	var rec_quests = interaction_panel.get_quests_progress()
	var rec_time = hud.get_time_left()
	recover_ends.emit(hud.score, rec_quests, rec_time)
	print(rec_quests + " " +  rec_time)
