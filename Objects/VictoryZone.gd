extends Area2D

export (String,FILE,"*tscn") var path

func _ready():
	$AnimationPlayer.play("portal")
func _on_ChangingScene_timeout():
	print(path)
	get_tree().change_scene(path)
	pass # Replace with function body.

func _on_VictoryZone_body_entered(body):
	if !body.is_dead:
		body.emit_signal("victory")
		print("changing scene")
		$ChangingScene.start()
