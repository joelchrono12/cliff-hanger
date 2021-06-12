extends Control

export (String,FILE,"*tscn") var path
export var level_num = "0" 
export var enabled = false
export var all_diamons = false

onready var level_label = $TextureButton/Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	level_label.text = level_num
	
	pass # Replace with function body.


func _on_TextureButton_pressed():
	if enabled:
		get_tree().change_scene(path)
