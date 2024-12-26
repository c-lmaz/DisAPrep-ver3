extends Panel

@onready var _999n = $"ScrollContainer/VBoxContainer/999N"
@onready var info_source_n = $ScrollContainer/VBoxContainer/InfoSourceN
@onready var emergency_kit_n = $ScrollContainer/VBoxContainer/EmergencyKitN
@onready var first_aid_n = $ScrollContainer/VBoxContainer/FirstAidN

@onready var drsn = $ScrollContainer/VBoxContainer/FirstAidN/DRSN
@onready var avpun = $ScrollContainer/VBoxContainer/FirstAidN/AVPUN
@onready var wounds_n = $ScrollContainer/VBoxContainer/FirstAidN/WoundsN
@onready var sprain_n = $ScrollContainer/VBoxContainer/FirstAidN/SprainN


func _ready():
	for button in $ScrollContainer/VBoxContainer.get_children():
		if button is Button:
			button.connect("toggled", _on_button_toggled.bind(button.name))


func _on_button_toggled(toggle: bool, b_name: String):
	pass
