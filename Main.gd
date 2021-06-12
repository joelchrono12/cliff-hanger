extends Node

var save_path = "user://save.dat"

func _ready():
	pass # Replace with function body.
func save_level(data):
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
		
func load_level():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path,File.READ)
		if error == OK:
			var player_data = file.get_var()
			file.close()
			return str(player_data)
			print("Loaded fine")
		else:
			print("something happened")
	else: 
		print("Loaded nothing")
		return "res://Levels/Level_0.tscn"
	
	
	
