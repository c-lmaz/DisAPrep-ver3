extends Panel

@onready var scroll_container = $ScrollContainer


func _ready():
	for button in $ScrollContainer/VBoxContainer.get_children():
		if button is Button:
			button.connect("toggled", _on_button_toggled.bind(button))
	
	for button in $ScrollContainer/VBoxContainer/FirstAidN.get_children():
		if button is Button:
			button.connect("toggled", _on_button_toggled.bind(button))


func _on_button_toggled(toggled_on: bool, button: Button):
	var b_name = button.name
	var note
	match b_name:
		"999": note = $"ScrollContainer/VBoxContainer/999N"
		"InfoSource": note = $ScrollContainer/VBoxContainer/InfoSourceN
		"EmergencyKit": note = $ScrollContainer/VBoxContainer/EmergencyKitN
		"FirstAid": note = $ScrollContainer/VBoxContainer/FirstAidN
		"DRS": note = $ScrollContainer/VBoxContainer/FirstAidN/DRSN
		"AVPU": note = $ScrollContainer/VBoxContainer/FirstAidN/AVPUN
		"Wounds": note = $ScrollContainer/VBoxContainer/FirstAidN/WoundsN
		"Sprain": note = $ScrollContainer/VBoxContainer/FirstAidN/SprainN
	
	note.visible = toggled_on
