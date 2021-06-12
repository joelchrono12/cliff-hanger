extends Timer

var seconds = 0
var minutes = 0
var recording
func _ready():
	pass

func _process(delta):
	pass
		
func _on_Camera2D_enable_movement():
	pass

func _on_TotalLevelTime_timeout():
	TotalTime.level_playtime_seconds+=1
	print("Tiempo (En movimiento): ",TotalTime.total_playtime)
	print("Tiempo (Total)", TotalTime.level_playtime_minutes," : ", TotalTime.level_playtime_seconds)
	#print(OS.get_ticks_msec())	
func _on_Player_victory():
	stop()




func _on_GUI_enable_camera():
	if !start():
		start()
	elif paused:
		paused = false


func _on_GUI_pause_camera():
	paused = true
