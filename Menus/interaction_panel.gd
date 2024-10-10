extends NinePatchRect

@onready var scroll_container = $ScrollContainer
@onready var item_container = $ScrollContainer/ItemContainer
var kit_items_path = "res://Data/Flood/prep_items.json"
var kit_items = Global.read_json_file(kit_items_path)
var kit_item_node = preload("res://Themes/Customs/item_button.tscn")


@onready var quest_container = $Quests/PanelContainer/QuestContainer
@onready var panel_container = $Quests/PanelContainer
@onready var current_quest = $CurrentQuest
var quest_path = "res://Data/Flood/quests.json"
var quests = Global.read_json_file(quest_path)
var quest_node = preload("res://Menus/quest_display.tscn")


# TODO: handle completed quests
# switch current quests (change parent)
# for kit_items: 2 columns
# for hazards_damages: 1 column
func _ready():
	kit_items = kit_items["kit_items"]
	for i in range(kit_items.size()):
		var child = kit_item_node.instantiate()
		item_container.add_child(child)
		child.item_name = kit_items[i]["name"]
		child.item_icon = load(kit_items[i]["icon"])
	
	quests = quests["Prepare"]
	for i in range(quests.size()):
		var child = quest_node.instantiate()
		if i == 0: 
			current_quest.add_child(child)
			child.current = true
		else: 
			quest_container.add_child(child)
			child.current = false
		
		child.quest = quests[i]["name"]
		child.q_total = quests[i]["total"]


func _on_quests_toggled(toggled_on):
	panel_container.visible = toggled_on
	scroll_container.visible = !toggled_on


func update_current_quest(add_prog: int):
	var curr_quest = current_quest.get_child(0)
	curr_quest.update_progress(add_prog)
