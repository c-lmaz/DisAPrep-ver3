extends CanvasLayer

@onready var camera = $SubViewport/House/Camera3D
@onready var texture_rect = $TextureRect

@onready var hud = $HUD
var level_phase = ["Flooood", "Prep"]

@onready var kit_items = $KitItems
var rooms = ["Outside", "Living", "Kitchen", "Bathroom", "Family", "Bedroom"]
var room_ind = 1

func _ready():
	hud.set_level_name(level_phase)
	
	hud.game_paused.connect(_on_hud_game_paused)


func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		if camera.position.x < 0:
			camera.position.x = 1.5
			camera.position.z = 3.1
			camera.rotation = Vector3(0,0,0)
			room_ind = 1
			kit_items.show_room(rooms[room_ind])
		
		elif camera.position.x < 13.5: 
			camera.position.x += 3
			room_ind += 1
			kit_items.show_room(rooms[room_ind])
		
		else: 
			camera.position.x = 13.5
			room_ind = 5
			kit_items.show_room(rooms[room_ind])
		
	
	if Input.is_action_just_pressed("ui_left"):
		if camera.position.x <= 1.5:
			camera.position.x = -1.9
			camera.position.z = 1.5
			camera.rotation = Vector3(0,PI/-2,0)
			room_ind = 0
			kit_items.show_room(rooms[room_ind])
		
		else: 
			camera.position.x -= 3
			room_ind -= 1
			kit_items.show_room(rooms[room_ind])


func _on_hud_game_paused(pause_state):
	texture_rect.visible = !pause_state
