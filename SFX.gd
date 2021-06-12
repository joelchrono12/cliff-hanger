extends Node

onready var jump = $jumpsound
onready var grab = $hurtsound
onready var dead = $deadsound
onready var vic = $victory
onready var coin = $coin
onready var select = $selection
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func stop_all_sounds():
	jump.volume_db = -120
	grab.volume_db = -120
	dead.volume_db = -120
	vic.volume_db = -120
	coin.volume_db = -120
	select.volume_db = -120
func play_all_sounds():
	jump.volume_db = -27
	grab.volume_db = -25
	dead.volume_db = -22
	vic.volume_db = -22
	coin.volume_db = -24
	select.volume_db=-24
