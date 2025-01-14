extends Node

var default_progress = {
	"Flood": {
		"Prepare": {
			"Score": 0,
			"TimeLeft": 0,
			"Kit": 0,
			"Hazards": 0,
			"Comm": 0,
			"Highscore": 0
		},
		"Respond": {
			"Score": 0,
			"TimeLeft": 0,
			"Evac": 0,
			"Highscore": 0
		},
		"Recover": {
			"Score": 0,
			"TimeLeft": 0,
			"Health": 0,
			"Repair": 0,
			"Future": 0,
			"Highscore": 0
		},
	},
}

func read_json_file(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var file_text = file.get_as_text()
	file.close()
	
	var json_parse = JSON.new()
	var error = json_parse.parse(file_text)
	
	if error == OK:
		return json_parse.data
	else:
		printerr("Error parsing JSON file", path, " : ", json_parse.get_error_message())


func read_level_progress():
	var save_path = "user://user_progress.save"
	var progress = default_progress
	
	if FileAccess.file_exists(save_path):
		progress = read_json_file(save_path)
		if progress == null:
			progress = default_progress
	
	return progress


func save_level_progress(level: String, phase: String, data: Dictionary):
	var save_path = "user://user_progress.save"
	var json_string
	var current_progress = default_progress
	
	if FileAccess.file_exists(save_path):
		current_progress = read_json_file(save_path)
		if current_progress == null:
			current_progress = default_progress
	
	if current_progress.has(level) and current_progress[level] is Dictionary:
		var level_dict = current_progress[level]
		if level_dict.has(phase) and level_dict[phase] is Dictionary:
			var phase_dict = level_dict[phase]
			for key in data:
				phase_dict[key] = data[key]
			if phase_dict["Highscore"] < data["Score"]:
				phase_dict["Highscore"] = data["Score"]
	
	else:
		if !current_progress.has(level):
			current_progress[level] = {}
		if !current_progress[level].has(phase):
			current_progress[level][phase] = {}
		
		for key in data:
			current_progress[level][phase][key] = data[key]
	
	json_string = JSON.stringify(current_progress, "\t")
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_string(json_string)
	print_debug(json_string)
	save_file.close()
