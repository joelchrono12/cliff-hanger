extends Area2D

signal add_time(time)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim_play =$AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("add_time",get_parent().get_parent().get_node("Background/GUI"),"add_time_now")
	anim_play.play("idle")
	connect("add_time",get_parent().get_node("Background/GUI"),"add_time_now")

func _on_Collectible_body_entered(body):
	emit_signal("add_time")
	$CollisionShape2D.set_deferred("disabled",true)
	Sfx.coin.play()
	anim_play.play("fade")
	TotalTime.collectibles +=1

	
