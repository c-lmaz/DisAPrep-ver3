extends CanvasLayer

@onready var camera = $SubViewport/House/Camera3D
@onready var texture_rect = $TextureRect

@onready var hud = $HUD

var subv_snapshot
var subv_tex
var level_phase = ["Flooood", "Prep"]

func _ready():
	hud.set_level_name(level_phase)
	
	hud.game_paused.connect(_on_hud_game_paused)


func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		if camera.position.x < 0:
			camera.position.x = 1.5
			camera.position.z = 3.1
			camera.rotation = Vector3(0,0,0)
		elif camera.position.x < 13.5: camera.position.x += 3
		else: camera.position.x = 13.5
		
	
	if Input.is_action_just_pressed("ui_left"):
		if camera.position.x <= 1.5:
			camera.position.x = -1.9
			camera.position.z = 1.5
			camera.rotation = Vector3(0,PI/-2,0)
		else: camera.position.x -= 3


func _on_hud_game_paused(pause_state):
	texture_rect.visible = !pause_state
