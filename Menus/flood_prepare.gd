extends CanvasLayer

@onready var camera = $SubViewport/House/Camera3D
@onready var texture_rect = $TextureRect
@onready var right = $TextureRect/Right
@onready var left = $TextureRect/Left
var rooms = ["Outside", "Living", "Kitchen", "Bathroom", "Family", "Bedroom"]
var room_ind = 1

@onready var hud = $HUD
var level_phase = ["Flooood", "Prep"]

@onready var interaction_panel = $InteractionPanel
@onready var item_container = $InteractionPanel/ScrollContainer/ItemContainer

@onready var kit_items = $KitItems
var correct_items: Array


func _ready():
	hud.set_level_name(level_phase)
	
	hud.game_paused.connect(_on_hud_game_paused)
	kit_items.items_collected.connect(_on_kit_items_collected)
	
	for child in item_container.get_children():
		correct_items.push_back(str(child.name))


func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		if camera.position.x < 0:
			camera.position.x = 1.5
			camera.position.z = 3.1
			camera.rotation = Vector3(0,0,0)
			room_ind = 1
			# get current quest in progress and change display accordingly
			kit_items.show_room(rooms[room_ind])
			left.visible = true
		
		elif camera.position.x < 13.5: 
			camera.position.x += 3
			room_ind += 1
			# get current quest in progress and change display accordingly
			kit_items.show_room(rooms[room_ind])
			if camera.position.x == 13.5:
				right.visible = false
		
		else: 
			camera.position.x = 13.5
			room_ind = 5
			# get current quest in progress and change display accordingly
			kit_items.show_room(rooms[room_ind])
		
	
	if Input.is_action_just_pressed("ui_left"):
		if camera.position.x <= 1.5:
			camera.position.x = -1.9
			camera.position.z = 1.5
			camera.rotation = Vector3(0,PI/-2,0)
			room_ind = 0
			# get current quest in progress and change display accordingly
			kit_items.show_room(rooms[room_ind])
			left.visible = false
		
		else: 
			camera.position.x -= 3
			room_ind -= 1
			# get current quest in progress and change display accordingly
			kit_items.show_room(rooms[room_ind])
			right.visible = true


func _on_hud_game_paused(pause_state):
	texture_rect.visible = !pause_state
	interaction_panel.visible = !pause_state



# TODO: handle these situations
# all items collected
# all spots done
# timeout
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
