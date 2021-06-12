extends Camera2D

onready var limits = get_parent().get_parent().limits

var victory_zoom = false
var enable_camera = false


func _ready():
	limit_left = limits[0]
	limit_right = limits[1]
	limit_top = limits[2]
	limit_bottom = limits[3]
	
func _process(delta):
#	if enable_camera == false and victory_zoom == false:
#		if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("pause"):
#			emit_signal("enable_movement")
#			enable_camera = true
	if enable_camera == true:
		#zoom = zoom.linear_interpolate(Vector2(1,1),0.1)
		zoom = zoom.linear_interpolate(Vector2(.8,.8),0.1)
#		if Input.is_action_just_pressed("pause"):
#			emit_signal("pause_movement")
#			enable_camera = false
#			print("PAUSED")
		#yield(get_tree().create_timer(2),"timeout")
	elif victory_zoom:
		zoom = zoom.linear_interpolate(Vector2(0.6,0.6),0.1)

func change_drag_margin(left,right):
	drag_margin_left = left
	drag_margin_right = right

func _on_Player_victory():
	change_drag_margin(0,0)
	enable_camera = false
	victory_zoom = true
	
