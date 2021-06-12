extends Control


# Declare member variables here. Examples:
# var a = 2
onready var button =$MarginContainer/CenterContainer/VBoxContainer/Button
onready var time = $MarginContainer/CenterContainer/VBoxContainer/TiempoSinContarLedgeGrabs
onready var ftime = $MarginContainer/CenterContainer/VBoxContainer/TiempoTotal
onready var collected = $"MarginContainer/CenterContainer/VBoxContainer/Collected stuff"
# Called when the node enters the scene tree for the first time.
func _ready():
	button.grab_focus()
	
	time.text = str("Play Time: ",TotalTime.final_level_playtime)
	
	ftime.text = str("Score Time: ",TotalTime.total_playtime)
	
	collected.text = str("Collected Tokens: ", TotalTime.collectibles)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Main.save_level("res://Levels/Level_0.tscn")
	get_tree().change_scene("res://GUI/MainMenu.tscn")
