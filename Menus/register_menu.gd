extends PanelContainer

signal reg_login()
signal registered()

@onready var warning = $VBoxContainer/Warning

func _ready():
	Firebase.Auth.signup_succeeded.connect(_on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(_on_signup_failed)
	


func _on_login_pressed():
	reg_login.emit()


func _on_register_pressed():
	var email = $VBoxContainer/Email/Email.text
	var password = $VBoxContainer/Password/Password.text
	var username = $VBoxContainer/Username/Username.text
	
	if email.is_empty():
		warning.text = "Please enter your email."
		warning.visible = true
	elif username.is_empty():
		warning.text = "Please enter a username."
		warning.visible = true
	elif password.is_empty():
		warning.text = "Please enter a password."
		warning.visible = true
	elif not is_strong_password(password):
		warning.text = "Your password must has a minimum of 8 characters, 1 uppercase alphabet, 1 lowercase alphabet, and 1 number."
		warning.visible = true
	else:
		warning.visible = false
		Firebase.Auth.signup_with_email_and_password(email, password)


func _on_signup_succeeded(auth):
	Firebase.Auth.signup_succeeded.disconnect(_on_signup_succeeded)
	Firebase.Auth.save_auth(auth)
	Global.save_default_progress()
	
	var username = $VBoxContainer/Username/Username.text
	Global.save_username(username)
	Global.save_to_cloud()
	registered.emit()


func _on_signup_failed(_error_code, message):
	warning.text = message.capitalize()
	warning.visible = true


func is_strong_password(password: String):
	var pattern = RegEx.new()
	pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")
	
	return pattern.search(password) != null
