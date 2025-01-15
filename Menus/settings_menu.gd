extends Control

@onready var login_menu = preload("res://Menus/login_menu.tscn")
var login_menu_node
@onready var register_menu = preload("res://Menus/register_menu.tscn")
var reg_menu_node
@onready var close = $Close

@onready var bgm_button = $MarginContainer/VBoxContainer/BGM/TextureButton

@onready var prep_h_score = $MarginContainer/VBoxContainer/Prepare/HScore
@onready var resp_h_score = $MarginContainer/VBoxContainer/Respond/HScore
@onready var rec_h_score = $MarginContainer/VBoxContainer/Recover/HScore
@onready var uname = $MarginContainer/VBoxContainer/Avatar/Label

func _ready():
	if AudioManager.bgm.playing:
		bgm_button.button_pressed = false
		bgm_button.icon = preload("res://Icons/Controls/musicOn.png")
	else:
		bgm_button.button_pressed = true
		bgm_button.icon = preload("res://Icons/Controls/musicOff.png")
	
	login_menu_node = login_menu.instantiate()
	add_child(login_menu_node)
	login_menu_node.visible = false
	reg_menu_node = register_menu.instantiate()
	add_child(reg_menu_node)
	reg_menu_node.visible = false
	
	login_menu_node.login_reg.connect(_on_login_reg_pressed)
	login_menu_node.logged_in.connect(_on_login_logged_in)
	
	reg_menu_node.reg_login.connect(_on_register_login_pressed)
	reg_menu_node.registered.connect(_on_login_logged_in)
	
	var cloud_save = await Global.load_from_cloud()
	
	var local_save = Global.read_level_progress()
	prep_h_score.text = str(local_save["Flood"]["PrepareHighscore"])
	resp_h_score.text = str(local_save["Flood"]["RespondHighscore"])
	rec_h_score.text = str(local_save["Flood"]["RecoverHighscore"])
	uname.text = local_save["username"]


func _on_login_reg_pressed():
	if reg_menu_node: reg_menu_node.visible = true
	else:
		reg_menu_node = register_menu.instantiate()
		add_child(reg_menu_node)
	close.visible = true


func _on_register_login_pressed():
	reg_menu_node.visible = false
	login_menu_node.visible = true


func _on_login_pressed():
	if login_menu_node: login_menu_node.visible = true
	else:
		login_menu_node = login_menu.instantiate()
		add_child(login_menu_node)
	
	close.visible = true


func _on_close_pressed():
	login_menu_node.visible = false
	reg_menu_node.visible = false
	close.visible = false


func _on_logout_pressed():
	Firebase.Auth.logout()
	var avatar = $MarginContainer/VBoxContainer/Avatar/Avatar
	
	avatar.texture = preload("res://Icons/Controls/singleplayer.png")
	Global.delete_save_file()
	var local_save = Global.read_level_progress()
	uname.text = local_save["username"]
	prep_h_score.text = str(local_save["Flood"]["PrepareHighscore"])
	resp_h_score.text = str(local_save["Flood"]["RespondHighscore"])
	rec_h_score.text = str(local_save["Flood"]["RecoverHighscore"])
	
	$MarginContainer/VBoxContainer/Login.visible = true
	$MarginContainer/VBoxContainer/Logout.visible = false


func _on_login_logged_in():
	var avatar = $MarginContainer/VBoxContainer/Avatar/Avatar
	
	avatar.texture = preload("res://Icons/Controls/player.png")
	var local_save = Global.read_level_progress()
	print(local_save)
	uname.text = local_save["username"]
	prep_h_score.text = str(local_save["Flood"]["PrepareHighscore"])
	resp_h_score.text = str(local_save["Flood"]["RespondHighscore"])
	rec_h_score.text = str(local_save["Flood"]["RecoverHighscore"])
	
	close.visible = false
	$MarginContainer/VBoxContainer/Login.visible = false
	$MarginContainer/VBoxContainer/Logout.visible = true
	if login_menu_node: login_menu_node.queue_free()
	if reg_menu_node: reg_menu_node.queue_free()


func _on_bgm_button_toggled(toggled_on):
	AudioManager.toggle_bgm(!toggled_on)
	
	if toggled_on:
		bgm_button.icon = preload("res://Icons/Controls/musicOff.png")
	else:
		bgm_button.icon = preload("res://Icons/Controls/musicOn.png")
