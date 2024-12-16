extends Node3D

signal path_ended(pathname: String)

@onready var camera = $Camera
@onready var paths = $Paths
@onready var path_follow = $Paths/Start_1/PathFollow3D

var current_path : String
var prev_path : Array
var speed = 0.5
var moving = true


func _ready():
	current_path = path_follow.get_parent().name
	prev_path.append(current_path)


func _process(delta):
	if moving:
		if not prev_path.is_empty():
			path_follow.progress_ratio += speed * delta
		
		if path_follow.progress_ratio == 1.0 or prev_path.is_empty():
			moving = false
			path_ended.emit(current_path)


func level_start():
	moving = true


func change_path(pathname: String):
	if pathname.match("DEAD"):
		if prev_path.size() > 1:
			current_path = prev_path[-1]
			prev_path.pop_back()
		else:
			current_path = prev_path[0]
	
	else:
		prev_path.append(current_path)
		current_path = pathname
	
	var new_path = paths.get_node(current_path)
	path_follow.reparent(new_path)
	
	if pathname.match("DEAD"): 
		path_follow.progress_ratio = 0.8
	else: path_follow.progress_ratio = 0.0
	
	moving = true
