extends Control


@onready var level_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/LevelTutorial
@onready var general_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/GeneralTutorial
@onready var prepare_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/PrepareTutorial
@onready var respond_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/RespondTutorial
@onready var recover_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/RecoverTutorial
@onready var start_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/GeneralTutorial/StartTutorial
@onready var exit_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/GeneralTutorial/ExitTutorial
@onready var quest_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/GeneralTutorial/QuestTutorial
@onready var pause_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/GeneralTutorial/PauseTutorial
@onready var kit_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/PrepareTutorial/KitTutorial
@onready var hazard_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/PrepareTutorial/HazardTutorial
@onready var contacts_tutorial = $MarginContainer/ScrollContainer/VBoxContainer/PrepareTutorial/ContactsTutorial



func _on_level_toggled(toggled_on): level_tutorial.visible = toggled_on

func _on_general_gameplay_toggled(toggled_on): general_tutorial.visible = toggled_on

func _on_start_level_toggled(toggled_on): start_tutorial.visible = toggled_on

func _on_exit_level_toggled(toggled_on): exit_tutorial.visible = toggled_on

func _on_quest_toggled(toggled_on): quest_tutorial.visible = toggled_on

func _on_pause_toggled(toggled_on): pause_tutorial.visible = toggled_on

func _on_prepare_level_toggled(toggled_on): prepare_tutorial.visible = toggled_on

func _on_kit_toggled(toggled_on): kit_tutorial.visible = toggled_on

func _on_hazards_toggled(toggled_on): hazard_tutorial.visible = toggled_on

func _on_contacts_toggled(toggled_on):contacts_tutorial.visible = toggled_on

func _on_respond_level_toggled(toggled_on): respond_tutorial.visible = toggled_on

func _on_recover_level_toggled(toggled_on): recover_tutorial.visible = toggled_on
