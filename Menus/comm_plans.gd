extends Panel

signal keypad_ok(emerg_no: String)


@onready var keypad = $Phone/EmergNo/Keypad
@onready var add_people = $Phone/FamilyChannel/AddPeople
@onready var messages_box = $Phone/FamilyChannel/Messages

var no_people_added = 0


func _ready():
	
	for key in keypad.get_children():
		if key is Button:
			key.connect("pressed", _on_keypad_pressed.bind(key))
	
	for person in add_people.get_children():
		if person is Button:
			person.connect("pressed", _on_add_people_pressed.bind(person))
	
	_messages_start()


func _on_keypad_pressed(key):
	var text_edit = $Phone/EmergNo/TextEdit
	var warning = $Phone/Warning
	var key_edit = key.name
	
	if text_edit.text.match("XXX"): text_edit.text = ""
	
	if warning.is_visible_in_tree(): warning.visible = false
	
	if key_edit.match("Del"): text_edit.text = text_edit.text.left(-1)
	
	elif key_edit.match("OK"): _on_keypad_ok(text_edit.text)
	
	elif text_edit.text.length() < 3: text_edit.text += key_edit
	
	elif text_edit.text.length() == 3: warning.visible = true


# TODO: connect keypad_ok in floodprepare
# TODO: once 999 is accepted, queuefree emergno & warning, start familychannel
func _on_keypad_ok(emerno: String): keypad_ok.emit(emerno)


func _on_add_people_pressed(person): _add_people(person.name)


func _add_people(person: String):
	var added_notif = $Phone/FamilyChannel/AddedNotif
	added_notif.text = person + " added to the chatroom 'Family'."
	added_notif.visible = true
	await get_tree().create_timer(1).timeout
	added_notif.visible = false
	
	var added = add_people.get_node(person)
	added.disabled = true
	
	no_people_added += 1
	if no_people_added == 5:
		add_people.queue_free()
		added_notif.queue_free()
		$Phone/FamilyChannel/Prompt.queue_free()
		messages_box.visible = true
		_messages_start()


func _messages_start():
	var messages = $Phone/FamilyChannel/Messages/Messages
	for message in messages.get_children():
		if not message.name.contains("Player"):
			message.visible = true
			await get_tree().create_timer(0.7).timeout
		
		# TODO: add player options
		else:
			message.visible = true
			await get_tree().create_timer(0.7).timeout
		
		
