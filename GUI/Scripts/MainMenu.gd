extends Control

onready var start_button = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/Play
onready var quit_button = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/Quit
onready var sfx_button = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/SFX
onready var music_button = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Music
onready var credits = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Credits
onready var credits_area = $Credits
onready var menu_area = $MarginContainer
onready var back_menu = $"Credits/VBoxContainer/MarginContainer/VBoxContainer/Back to menu"
onready var steven = $Credits/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/LinkButton
onready var joel = $Credits/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/MyLink
onready var anim = $AnimationPlayer
onready var effect_sprite = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/SFX/Sprite
onready var music_sprite = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Music/Sprite
var pos_list = 0

func _ready():
	print()
	get_tree().paused = false
	if GlobalAudioStreamPlayer.volume_db !=-8:
		music_button.pressed = true
	else: 
		music_button.pressed = false
	if Sfx.jump.volume_db != -27:
		sfx_button.pressed = true
	else:
		sfx_button.pressed = false
	start_button.grab_focus()
	menu_area.visible = true
	credits_area.visible = false
func _process(delta):
	if Input.is_action_just_pressed("down"):
		pos_list+=1
	elif Input.is_action_just_pressed("up"):
		pos_list-=1
	if pos_list>5: pos_list = 0
	elif pos_list<0: pos_list = 5
	
func _on_Play_pressed():
	anim.play("play")
	Sfx.select.play()

func play_game():
	get_tree().change_scene(Main.load_level())
	print(Main.load_level())
	
func _on_Quit_pressed():
	anim.play("quit")
	Sfx.select.play()
	
func quit_game():
	get_tree().quit()

func _on_SFX_toggled(button_pressed):
	if button_pressed: 
		anim.play("sound")
		Sfx.stop_all_sounds() 
	else: 
		anim.play_backwards("sound")
		Sfx.play_all_sounds()

func _on_Music_toggled(button_pressed):
	if button_pressed: 
		anim.play("music")
		GlobalAudioStreamPlayer.volume_db = -120
	else:
		anim.play_backwards("music")
		GlobalAudioStreamPlayer.volume_db = 0


func _on_Back_to_menu_pressed():
	credits_area.visible = false
	menu_area.visible = true
	start_button.grab_focus()


func _on_Credits_pressed():
	anim.play("more")
	
func share_menu():
	menu_area.visible = false
	credits_area.visible = true
	back_menu.grab_focus()
	


func _on_LinkButton_pressed():
	OS.shell_open("https://twitter.com/stevenwahlmusic")
	
func _on_MyLink_pressed():
	OS.shell_open("https://twitter.com/Joeligj12")


func _on_Play_mouse_entered():
	start_button.grab_focus()
	Sfx.select.play()


func _on_Quit_mouse_entered():
	quit_button.grab_focus()
	Sfx.select.play()


func _on_Music_mouse_entered():
	music_button.grab_focus()
	Sfx.select.play()





func _on_Credits_mouse_entered():
	credits.grab_focus()
	Sfx.select.play()


func _on_SFX_mouse_entered():
	sfx_button.grab_focus()
	Sfx.select.play()
	


func _on_LinkButton_mouse_entered():
	steven.grab_focus()
	Sfx.select.play()


func _on_MyLink_mouse_entered():
	joel.grab_focus()
	Sfx.select.play()


