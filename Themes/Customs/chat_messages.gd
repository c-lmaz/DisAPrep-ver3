@tool

extends VBoxContainer

@export var is_player : bool = false
@export var has_name : bool = false
@export var chat_name : String
@export_multiline var chat_message : String

@onready var ch_name = $ChatName
@onready var message = $Message
@onready var filler = $GGFiller


func _ready():
	_update()


func update_chat():
	_update()


func _update():
	if has_name:
		ch_name.visible = true
		filler.visible = true
	else:
		ch_name.visible = false
		filler.visible = false
	
	if is_player:
		ch_name.text = "[right][b][i]" + chat_name + "[/i][/b][/right]"
	else:
		ch_name.text = "[b][i]" + chat_name + "[/i][/b]"
	
	message.text = chat_message
