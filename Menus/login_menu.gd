extends PanelContainer

signal login_reg()
signal logged_in()

@onready var warning = $VBoxContainer/Warning


func _ready():
	Firebase.Auth.login_succeeded.connect(_on_login_succeeded)
	Firebase.Auth.login_failed.connect(_on_login_failed)


func _on_register_pressed():
	login_reg.emit()


func _on_login_pressed():
	var email = $VBoxContainer/Email/Email.text
	var password = $VBoxContainer/Password/Password.text
	print("logging in")
	
	if email.is_empty():
		warning.text = "Please enter your email."
		warning.visible = true
	elif password.is_empty():
		warning.text = "Please enter your password."
		warning.visible = true
	else:
		warning.visible = false
		Firebase.Auth.login_with_email_and_password(email, password)


func _on_login_succeeded(auth):
	Firebase.Auth.save_auth(auth)
	Global.load_from_cloud()
	logged_in.emit()
	print("logged in")
	Firebase.Auth.login_succeeded.disconnect(_on_login_succeeded)


func _on_login_failed(error_code, message):
	warning.text = message.capitalize()
	warning.visible = true
