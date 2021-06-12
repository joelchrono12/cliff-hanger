extends Area2D



func _ready():
	pass

func _on_Spikes_body_entered(body):
	body.emit_signal("killed")
	$CollisionShape2D.set_deferred("disabled",true)
	
		
