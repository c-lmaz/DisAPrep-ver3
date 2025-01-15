extends Node


var COLLECTION_ID = "user_stats"

var default_progress = {
	"username": "Guest",
	
	"Flood": {
		"PrepareHighscore": 0,
		"RespondHighscore": 0,
		"RecoverHighscore": 0,
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


func save_default_progress():
	var save_path = "user://user_progress.save"
	var json_string
	var current_progress
	
	if FileAccess.file_exists(save_path):
		current_progress = read_json_file(save_path)
		if current_progress == null:
			current_progress = default_progress
	else:
		current_progress = default_progress
	
	json_string = JSON.stringify(current_progress, "\t")
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_string(json_string)
	save_file.close()


func save_level_progress(level: String, phase: String, score: int):
	var save_path = "user://user_progress.save"
	var json_string
	var current_progress = default_progress
	
	if FileAccess.file_exists(save_path):
		current_progress = read_json_file(save_path)
		if current_progress == null:
			current_progress = default_progress
	
	if current_progress.has(level) and current_progress[level] is Dictionary:
		var level_dict = current_progress[level]
		match phase:
			"Prepare":
				if level_dict["PrepareHighscore"] < score:
					level_dict["PrepareHighscore"] = score
			"Respond":
				if level_dict["RespondHighscore"] < score:
					level_dict["RespondHighscore"] = score
			"Recover":
				if level_dict["RecoverHighscore"] < score:
					level_dict["RecoverHighscore"] = score
	
	json_string = JSON.stringify(current_progress, "\t")
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_string(json_string)
	save_file.close()


func delete_save_file():
	var save_path = "user://user_progress.save"
	DirAccess.remove_absolute(save_path)
	save_default_progress()


func save_username(username: String):
	var save_path = "user://user_progress.save"
	var json_string
	var current_progress
	
	if FileAccess.file_exists(save_path):
		current_progress = read_json_file(save_path)
		if current_progress == null:
			current_progress = default_progress
	
	current_progress["username"] = username
	json_string = JSON.stringify(current_progress, "\t")
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_string(json_string)
	save_file.close()


func save_to_cloud():
	if Firebase.Auth.check_auth_file():
		var auth = Firebase.Auth.auth
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var data: Dictionary = read_level_progress()
		var document = await collection.get_doc(auth.localid)
		
		if document:
			for key in data.keys():
				document.add_or_update_field(key, data[key])
			var task = await collection.update(document)
			if task:
				print("Document updated successfully")
			else:
				print("Failed to update document")
		else:
			document = await collection.add(auth.localid, data)
			if document:
				print("Document created successfully")
			else:
				print("Failed to create document")


func load_from_cloud():
	if Firebase.Auth.check_auth_file():
		var auth = Firebase.Auth.auth
		var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var document = await collection.get_doc(auth.localid)
		
		if document:
			var progress = {
				"username": document.get_value("username"),
				"Flood": document.get_value("Flood")
			}
			
			save_level_progress("Flood", "Prepare", progress["Flood"]["PrepareHighscore"])
			save_level_progress("Flood", "Respond", progress["Flood"]["RespondHighscore"])
			save_level_progress("Flood", "Recover", progress["Flood"]["RecoverHighscore"])
			save_username(progress["username"])
			
			
			return progress
		else:
			print("Failed to load document")
			return {}
	
	else:
		print("Not logged in")
		return {}
