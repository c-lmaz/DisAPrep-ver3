extends PanelContainer

signal reg_login()
signal registered()

func _ready():
	Firebase.Auth.signup_succeeded.connect(_on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(_on_signup_failed)
	


func _on_login_pressed():
	reg_login.emit()


func _on_register_pressed():
	var email = $VBoxContainer/Email/Email.text
	var password = $VBoxContainer/Password/Password.text
	
	Firebase.Auth.signup_with_email_and_password(email, password)


func _on_signup_succeeded(auth):
	Firebase.Auth.signup_succeeded.disconnect(_on_signup_succeeded)
	Firebase.Auth.save_auth(auth)
	Global.save_default_progress()
	
	var username = $VBoxContainer/Username/Username.text
	Global.save_username(username)
	Global.save_to_cloud()
	registered.emit()


func _on_signup_failed(error_code, message):
	print(error_code)
	print(message)
