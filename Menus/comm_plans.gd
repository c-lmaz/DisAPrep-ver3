extends Panel

signal keypad_ok(emerg_no: String)
signal chat_selected(option: String)
signal comm_plans_completed()

@onready var emerg_no = $Phone/EmergNo
@onready var keypad = $Phone/EmergNo/Keypad
@onready var add_people = $Phone/FamilyChannel/AddPeople
@onready var messages_box = $Phone/FamilyChannel/Messages
@onready var messages = $Phone/FamilyChannel/Messages/Messages
@onready var family_channel = $Phone/FamilyChannel

var no_people_added = 0
var curr_opt_ind = 0
var wait_for_input = false
var opt_eval = false

func _ready():
	
	for key in keypad.get_children():
		if key is Button:
			key.connect("pressed", _on_keypad_pressed.bind(key))
	
	for person in add_people.get_children():
		if person is Button:
			person.connect("pressed", _on_add_people_pressed.bind(person))
	
	for option in messages.get_children():
		if option is ChatOption:
			option.connect("chat_selected", _on_chat_selected)


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


func _on_keypad_ok(emerno: String): keypad_ok.emit(emerno)


func start_family():
	emerg_no.visible = false
	family_channel.visible = true
	add_people.visible = true
	$Phone/FamilyChannel/Prompt.visible = true
	
	emerg_no.queue_free()
	$Phone/Warning.queue_free()


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
		add_people.visible = false
		added_notif.visible = false
		$Phone/FamilyChannel/Prompt.visible = false
		
		messages_box.visible = true
		
		add_people.queue_free()
		added_notif.queue_free()
		$Phone/FamilyChannel/Prompt.queue_free()
		
		_messages_start()


func _messages_start():
	var next_message = false
	for message in messages.get_children():
		var is_correct = message.name.contains("Correct")
		var is_wrong = message.name.contains("Wrong")
		var is_choice = message.name.contains("Choice")
		
		if (is_correct):
			if next_message: 
				message.visible = true
				await get_tree().create_timer(0.8).timeout
			else: continue
		
		elif (is_wrong):
			if not next_message: 
				message.visible = true
				await get_tree().create_timer(0.8).timeout
			else: continue
		
		elif is_choice:
			message.visible = true
			wait_for_input = true
			curr_opt_ind = message.get_index()
			while wait_for_input:
				await get_tree().create_timer(0.1).timeout
			
			message.visible = false
			if opt_eval: next_message = true
			else: next_message = false
		
		else:
			message.visible = true
			await get_tree().create_timer(0.8).timeout
	
	emit_signal("comm_plans_completed")


func _on_chat_selected(opt_name, text):
	var next_message = messages.get_child(curr_opt_ind+1)
	next_message.chat_message = text
	next_message.update_chat()
	chat_selected.emit(opt_name)
	wait_for_input = false

