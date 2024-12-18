extends Control


# TODO: handle exit menu

signal game_paused(pause_state: bool)
signal player_died

# LevelPhase variables
@onready var level = $LevelPhase/Level
@onready var phase = $LevelPhase/Phase

# Displays variables
@onready var timer = $Timer
@onready var lives = $Displays/LifeDisplay/Lives
@onready var score_label = $Displays/ScoreDisplay/HBoxContainer/Score
@onready var minute = $Displays/TimeDisplay/HBoxContainer/Minute
@onready var second = $Displays/TimeDisplay/HBoxContainer/Second

# Pause and Exit variables
@onready var pause_menu = $PauseMenu
@onready var exit_menu = $ExitMenu
@onready var pause = $Pause

var life = 6
var score = 0
var mins
var secs

func _ready():
	update_life(0)
	update_score(0)
	
	pause_menu.resume_pressed.connect(_on_pause_toggled)
	pause_menu.exit_pressed.connect(_on_exit_pressed)


func _process(_delta):
	var time_left = int(timer.time_left)
	mins = floor(time_left / 60)
	secs = int(time_left % 60)
	minute.text = str(mins)
	second.text = "%02d" % secs


func get_time_left(): 
	#timer.stop()
	return int(timer.time_left)

func set_level_name(level_name: Array):
	level.text = level_name[0]
	phase.text = level_name[1]


func set_timer(time: int): timer.wait_time = time


func start(): timer.start()


func update_life(add_life):
	life += add_life
	lives.update_hearts(life)
	if life == 0:
		player_died.emit()


func update_score(add_score):
	score += add_score
	score_label.text = str(score)


# Signal Functions

func _on_pause_toggled(toggled_on):
	game_paused.emit(toggled_on)
	pause.toggled(toggled_on)
	pause_menu.visible = toggled_on
	exit_menu.visible = false
	get_tree().paused = toggled_on


func _on_exit_pressed():
	pause_menu.visible = false
	exit_menu.visible = true
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _on_timer_timeout():
	player_died.emit()
