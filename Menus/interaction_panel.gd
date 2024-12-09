extends NinePatchRect

signal quest_completed(q_name: String)

@onready var scroll_container = $ScrollContainer
@onready var item_container = $ScrollContainer/ItemContainer
var prep_items_path = "res://Data/Flood/prep_items.json"
var prep_items = Global.read_json_file(prep_items_path)
var prep_item_node = preload("res://Themes/Customs/item_button.tscn")


@onready var quest_container = $Quests/PanelContainer/QuestContainer
@onready var panel_container = $Quests/PanelContainer
@onready var current_quest = $CurrentQuest
var quest_path = "res://Data/Flood/quests.json"
var quests = Global.read_json_file(quest_path)
var quest_node = preload("res://Menus/quest_display.tscn")

@export var is_small = false
enum QuestToggle{OFF, QUEST, ALLQUEST}
var next_toggle = QuestToggle.QUEST


# TODO: handle completed quests
# switch current quests (change parent)
# for prep_items: 2 columns
# for hazards_damages: 1 column
func _ready():
	
	set_next_quest_items(0)
	
	quests = quests["Prepare"]
	for i in range(quests.size()):
		var child = quest_node.instantiate()
		child.quest = quests[i]["name"]
		child.short_name = quests[i]["short"]
		child.q_total = quests[i]["total"]
		if i == 1: 
			current_quest.add_child(child)
			child.current = true
		else: 
			quest_container.add_child(child)
			child.current = false
		
	var curr_q_child = current_quest.get_child(0)
	if curr_q_child is QuestDisplay:
		curr_q_child.connect("quest_completed", _on_quest_completed)


func _on_quests_toggled(toggled_on):
	if is_small:
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
	
	else:
		panel_container.visible = toggled_on
		scroll_container.visible = !toggled_on


func get_current_quest():
	return current_quest.get_child(0).name


func update_current_quest(add_prog: int):
	var curr_quest = current_quest.get_child(0)
	curr_quest.update_progress(add_prog)


# TODO: set next quest as current 
# DONE: prepare the items
func set_next_quest_items(ind: int):
	
	for child in item_container.get_children():
		child.queue_free()
	
	match ind:
		0:
			prep_items = prep_items["kit_items"]
		1:
			prep_items = prep_items["hazards"]
	
	for i in range(prep_items.size()):
		var child = prep_item_node.instantiate()
		item_container.add_child(child)
		child.item_name = prep_items[i]["name"]
		child.item_icon = load(prep_items[i]["icon"])
		if prep_items[i].has("short"):
			child.short_name = prep_items[i]["short"]


func _on_quest_completed(q_name: String):
	quest_completed.emit(q_name)
