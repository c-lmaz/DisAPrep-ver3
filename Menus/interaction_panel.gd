extends NinePatchRect

signal quest_completed(q_name: String)

enum Phases{PREPARE, RESPOND, RECOVER}
@export var phase : Phases

@onready var scroll_container = $ScrollContainer
@onready var item_container = $ScrollContainer/ItemContainer
var item_node = preload("res://Themes/Customs/item_button.tscn")
var items_path
var items_all
var prep_items
var rec_items

@onready var quest_container = $Quests/PanelContainer/QuestContainer
@onready var panel_container = $Quests/PanelContainer
@onready var current_quest = $CurrentQuest
var quest_path = "res://Data/Flood/quests.json"
var quests = Global.read_json_file(quest_path)
var quest_node = preload("res://Menus/quest_display.tscn")

@export var is_small = false
enum QuestToggle{OFF, QUEST, ALLQUEST}
var next_toggle = QuestToggle.QUEST


func _ready():
	
	set_quests()
	set_next_quest_items(0)
	_draw_small()


func _draw_small():
	if is_small:
		custom_minimum_size.y = 80
	else:
		custom_minimum_size.y = 370


func set_quests():
	match phase:
		Phases.PREPARE:
			items_path = "res://Data/Flood/prep_items.json"
			items_all = Global.read_json_file(items_path)
			quests = quests["Prepare"]
		Phases.RESPOND:
			quests = quests["Respond"]
			scroll_container.queue_free()
			scroll_container = null
			is_small = true
		Phases.RECOVER:
			items_path = "res://Data/Flood/rec_items.json"
			items_all = Global.read_json_file(items_path)
			item_container.columns = 1
			quests = quests["Recover"]
	
	for i in range(quests.size()):
		var child = quest_node.instantiate()
		child.quest = quests[i]["name"]
		child.short_name = quests[i]["short"]
		child.q_total = quests[i]["total"]
		if child is QuestDisplay:
			child.connect("quest_completed", _on_quest_completed)
		if i == 0: 
			current_quest.add_child(child)
			child.current = true
		else: 
			quest_container.add_child(child)
			child.current = false


func get_current_quest(): return current_quest.get_child(0).name


func update_current_quest(add_prog: int):
	var curr_quest = current_quest.get_child(0)
	curr_quest.update_progress(add_prog)


func set_next_quest():
	var comp_quest = current_quest.get_child(0)
	comp_quest.reparent(quest_container)
	comp_quest.current = false
	
	var next_quest = quest_container.get_child(1)
	next_quest.reparent(current_quest)
	next_quest.position = Vector2(0,0)
	next_quest.current = true
	
	match next_quest.name:
		"Hazards": item_container.columns = 1
		"Comm": item_container.columns = 1


func set_next_quest_items(ind: int):
	item_container.clear_children()
	
	match phase:
		Phases.PREPARE:
			match ind:
				0:
					prep_items = items_all["kit_items"]
					is_small = false
				1:
					prep_items = items_all["hazards"]
					is_small = false
				2:
					prep_items = items_all["communication"]
					is_small = true
			
			for i in range(prep_items.size()):
				var child = item_node.instantiate()
				child.item_name = prep_items[i]["name"]
				child.item_icon = load(prep_items[i]["icon"])
				if prep_items[i].has("short"):
					child.short_name = prep_items[i]["short"]
				item_container.add_child(child)
		
		Phases.RESPOND:
			pass
		
		Phases.RECOVER:
			match ind:
				0: rec_items = items_all["health"]
				1: rec_items = items_all["repair"]
				2: rec_items = items_all["future"]
			
			for i in range(rec_items.size()):
				var child = item_node.instantiate()
				item_container.add_child(child)
				child.item_name = rec_items[i]["name"]
				child.item_icon = load(rec_items[i]["icon"])
				if rec_items[i].has("short"):
					child.short_name = rec_items[i]["short"]
	
	_draw_small()


func get_quests_progress():
	if current_quest.get_child(0):
		var comp_quest = current_quest.get_child(0)
		comp_quest.reparent(quest_container)
		comp_quest.current = false
	
	var quest_progress = {}
	
	for quest in quest_container.get_children():
		if quest is QuestDisplay:
			var quest_name = quest.name
			var quest_value = quest.curr_val
			quest_progress[quest_name] = quest_value
	
	return quest_progress


func _on_quest_completed(q_name: String): quest_completed.emit(q_name)


func _on_quests_toggled(toggled_on):
	if is_small and scroll_container:
		match next_toggle:
			QuestToggle.OFF:
				next_toggle = QuestToggle.QUEST
				custom_minimum_size.y = 80
				panel_container.visible = false
				scroll_container.visible = true
			
			QuestToggle.QUEST:
				next_toggle = QuestToggle.ALLQUEST
				custom_minimum_size.y = 370
			
			QuestToggle.ALLQUEST:
				next_toggle = QuestToggle.OFF
				panel_container.visible = true
				scroll_container.visible = false
	
	elif scroll_container:
		panel_container.visible = toggled_on
		scroll_container.visible = !toggled_on

