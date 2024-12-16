extends Node3D

@onready var camera = $Camera3D


func move_left():
	if camera.position.x <= 1.5:
		camera.position.x = -1.9
		camera.position.z = 1.5
		camera.rotation = Vector3(0,PI/-2,0)
		
	else: 
		camera.position.x -= 3


func move_right():
	if camera.position.x < 0:
		camera.position.x = 1.5
		camera.position.z = 3.1
		camera.rotation = Vector3(0,0,0)
	
	elif camera.position.x < 13.5: 
		camera.position.x += 3
	
	else: 
		camera.position.x = 13.5
