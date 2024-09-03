extends NinePatchRect

@onready var scroll_container = $ScrollContainer
@onready var item_container = $ScrollContainer/ItemContainer
var kit_items_path = "res://Data/Flood/Emergency Kit/kit_item.json"
var kit_items = Global.read_json_file(kit_items_path)
var kit_item_node = preload("res://Themes/Customs/item_button.tscn")


@onready var quest_container = $Quests/PanelContainer/QuestContainer
@onready var panel_container = $Quests/PanelContainer
@onready var current_quest = $CurrentQuest
var quest_path = "res://Data/Flood/quests.json"
var quests = Global.read_json_file(quest_path)
var quest_node = preload("res://Menus/quest_display.tscn")



func _ready():
	kit_items = kit_items["items"]
	for i in range(kit_items.size()):
		var child = kit_item_node.instantiate()
		item_container.add_child(child)
		# TODO: change kit_item json structure and update icons path
		#child.item_name = kit_items[i][0]
		#child.item_icon = preload(kit_items[i][1])
	
	quests = quests["Prepare"]
	for i in range(quests.size()):
		var child = quest_node.instantiate()
		if i == 0: 
			current_quest.add_child(child)
			child.current = true
		else: 
			quest_container.add_child(child)
			child.current = false
		
		child.quest = quests[i][0]
		child.q_total = quests[i][1]


func _on_quests_toggled(toggled_on):
	panel_container.visible = toggled_on
	scroll_container.visible = !toggled_on
