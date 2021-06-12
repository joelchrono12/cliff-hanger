extends Control

export (String,FILE,"*tscn") var path

signal enable_camera
signal pause_camera

onready var timer = $AllowedGrabTimer
onready var extra_timer = $ExtraTimer
onready var pb = $MarginContainer/VBoxContainer/ProgressBar
onready var time_label = $MarginContainer/VBoxContainer/Label
onready var start = $MarginContainer/CenterContainer/Label
onready var pause_menu = $PauseMenu
onready var GUI =$MarginContainer
onready var continues = $PauseMenu/CenterContainer/VBoxContainer/Continue
onready var restart = $PauseMenu/CenterContainer/VBoxContainer/Restart
onready var sfxx = $PauseMenu/CenterContainer/VBoxContainer/SFX
onready var music = $PauseMenu/CenterContainer/VBoxContainer/Music
onready var menu = $PauseMenu/CenterContainer/VBoxContainer/Menu
onready var jump_button = $InputControlsAndroid/CenterContainer/jump
onready var touch_input = $InputControlsAndroid
var pause_can_pause = true
var timer_started = false
var final_time
var refill = 0.1
var game_paused
var can_pause = true
var can_restart = true
var pos_list = 0
var game_started
var extra = 0
func _ready():
	connect_signals()
	check_audio()
	pause_menu.visible = false
	game_started = false
	touch_input.visible = true
	touch_input.visible = false
	pb.value = timer.time_left 
	timer.start()
	timer.paused = true
	

func _process(delta):
	if game_started ==false:
		if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("pause"):
			
			enable_level()
			print("WHAT IS GOING ON")
			game_started = true
			can_pause = true
	if game_started == true and can_pause == true:
		if Input.is_action_just_pressed("pause"):
			emit_signal("pause_camera")
			disable_level()
			print("PAUSED")
	
	if Input.is_action_just_pressed("restart") and can_restart:
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("fs"):
		if !OS.window_fullscreen:
			OS.window_fullscreen = true
		else:
			OS.window_fullscreen = false
			
	if final_time == null: 
		pb.value = timer.time_left
	else:
		pb.value = final_time
		final_time+=refill
	#print(pb.value)

func add_time_now():
	print("TIME ADDED")
	timer.paused = true
	extra = extra_timer.wait_time
	extra_timer.start()
	print("TIME ADDED")

func control_pause_menu():
	continues.grab_focus()
	
	
func _on_Player_wall_slide_state():
	timer.paused = true
	pause_can_pause = false

func _on_Player_wall_slide_exited():
	timer.paused = false
	pause_can_pause = true
	

func _on_Player_state_change(states,state):
	time_label.text = str("Current state: ",states.keys()[state])

func _on_Camera2D_enable_movement():
	pass
	
func enable_level():
	emit_signal("enable_camera")
	pause_menu.visible = false
	touch_input.visible = true
	GUI.visible = true
	get_tree().paused = false
	print("ENABLED")
	if pause_can_pause == true:
		timer.paused = false
	start.text = ""
	timer_started = true
	$AnimationPlayer.play("fading")
	
func _on_Player_victory():
	can_restart = false
	$AnimationPlayer.play_backwards("fading")
	start.text = "LEVEL COMPLETED!, next level incoming\n\n"
	final_time = timer.time_left
	TotalTime.total_playtime += 12-final_time
	timer.paused = true
	pb.value = final_time
	timer.stop()
	#return final_time

func _on_Player_killed():
	$AnimationPlayer.play_backwards("fading")
	start.text = "You died, R to RESTART"
	timer.paused = true
	touch_input.visible = true

func disable_level():
	get_tree().paused = true
	pause_menu.visible = true
	touch_input.visible = false
	GUI.visible = false
	control_pause_menu()
	print("TREE PAUSED")
	$AnimationPlayer.play_backwards("fading")
	start.text = "PAUSE, ENTER to continue"
	timer.paused = true
	can_pause = false

func _on_Restart_pressed():
	Sfx.select.play()
	get_tree().reload_current_scene()


func _on_SFX_toggled(button_pressed):
	Sfx.select.play()
	if button_pressed:
		Sfx.stop_all_sounds()
	else:
		Sfx.play_all_sounds()


func _on_Button3_toggled(button_pressed):
	Sfx.select.play()
	if button_pressed: GlobalAudioStreamPlayer.volume_db = -120
	else: GlobalAudioStreamPlayer.volume_db = 0


func _on_Button4_pressed(): #EXIT AND SAVE
	Sfx.select.play()
	var data = path
	Main.save_level(data)
	get_tree().change_scene("res://GUI/MainMenu.tscn")


func _on_Restart_mouse_entered():
	restart.grab_focus()


func _on_SFX_mouse_entered():
	sfxx.grab_focus()
func _on_Music_mouse_entered():
	music.grab_focus()
func _on_Menu_mouse_entered():
	menu.grab_focus()

func _on_Continue_pressed():
	Sfx.select.play()
	enable_level()
	can_pause = true



func check_audio():
	if GlobalAudioStreamPlayer.volume_db !=-8:
		music.pressed = true
	else: 
		music.pressed = false
	if Sfx.jump.volume_db == -120:
		sfxx.pressed = true
	else:
		sfxx.pressed = false
#jump_button.global_position = get_global_mouse_position()-Vector2(48,-48) if get_global_mouse_position().x>350 else jump_button.global_position.linear_interpolate(Vector2(625,365),0.1)


func connect_signals():
	connect("enable_camera",get_parent().get_parent().get_node("Player"),"_on_GUI_enable_camera")
	connect("pause_camera",get_parent().get_parent().get_node("Player"),"_on_GUI_pause_camera")
	connect("enable_camera",get_parent().get_parent().get_node("TotalLevelTime"),"_on_GUI_enable_camera")
	connect("pause_camera",get_parent().get_parent().get_node("TotalLevelTime"),"_on_GUI_pause_camera")
	timer.connect("timeout",get_parent().get_parent().get_node("Player"),"_on_AllowedGrabTimer_timeout")


func _on_ExtraTimer_timeout():
	if pause_can_pause == true:
		timer.paused=false
