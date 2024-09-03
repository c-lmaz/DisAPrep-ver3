extends Control

# Displays variables
@onready var timer = $Timer
@onready var lives = $Displays/LifeDisplay/Lives
@onready var score_label = $Displays/ScoreDisplay/HBoxContainer/Score
@onready var minute = $Displays/TimeDisplay/HBoxContainer/Minute
@onready var second = $Displays/TimeDisplay/HBoxContainer/Second

# Pause and Exit variables
@onready var exit = $Exit

var life = 3
var score = 0
var mins
var secs


func _ready():
	update_life()
	update_score(0)
	timer.start()


func _process(_delta):
	var time_left = int(timer.time_left)
	mins = floor(time_left / 60)
	secs = int(time_left % 60)
	minute.text = str(mins)
	second.text = "%02d" % secs


func update_life():
	lives.update_hearts(life)


func update_score(add_score):
	score += add_score
	score_label.text = str(score)


func _on_pause_toggled(toggled_on):
	exit.visible = toggled_on
	get_tree().paused = toggled_on
