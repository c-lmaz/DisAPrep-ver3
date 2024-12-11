extends Node

var default_progress = {
	"Flood": {
		"Prepare": {
			"Score": 0,
			"TimeLeft": 0,
			"CompleteKit": false
		},
		"RespondEvac": {
			"Score": 0,
			"TimeLeft": 0,
			"AllCorrect": false
		},
		"Recover": {
			"Score": 0,
			"TimeLeft": 0,
			"FuturePrep": false
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


func save_level_progress(level: String, phase: String, data: Dictionary):
	var save_path = "user://user_progress.save"
	var json_string
	
	if !FileAccess.file_exists(save_path):
		var create_file = FileAccess.open(save_path, FileAccess.WRITE)
		json_string = JSON.stringify(default_progress, "\t")
		create_file.store_line(json_string)
		create_file.close()
	
	var save_file = FileAccess.open(save_path, FileAccess.READ_WRITE)
	var current_progress = read_json_file(save_path)
	
	if current_progress.has(level) and current_progress[level] is Dictionary:
		var level_dict = current_progress[level]
		if level_dict.has(phase) and level_dict[phase] is Dictionary:
			var phase_dict = level_dict[phase]
			for key in data:
				phase_dict[key] = data[key]
	
	json_string = JSON.stringify(current_progress, "\t")
	save_file.store_string(json_string)
	save_file.close()
