extends KinematicBody2D


const UP = Vector2.UP

signal wall_slide_state 
signal wall_slide_exited
signal victory()
signal state_change(states,state)
signal killed()

var velocity = Vector2()
var WALL_JUMP_VELOCITY = Vector2(12*13,-200)
var KNOCKBACK_VELOCITY = Vector2(12*5,-100)

export var move_speed = 12*10
export var jump_velocity=-220
export var gravity = 420

var is_grounded
var is_on_edge
var is_jumping = false
var is_dead = false
var has_won = false
var stick_to_wall = false
var can_coyote_time = false
var wall_direction = 1
var snap = Vector2.DOWN*12
var slide_velocity
var current_state = null

onready var grabbing_shape = $Grabbing_shape
onready var left_raycast = $WallGrabRaycast/Right
onready var right_raycast = $WallGrabRaycast/Left
onready var other_left_raycast = $WallGrabRaycast/Right/RightWall
onready var other_right_raycast = $WallGrabRaycast/Left/LeftWall
onready var sticky_rightcast = $WallGrabRaycast/Right/RightWall2
onready var sticky_leftcast = $WallGrabRaycast/Left/LeftWall2
onready var moving_rightcast = $WallGrabRaycast/Right/RightWall3
onready var moving_leftcast = $WallGrabRaycast/Left/LeftWall3
onready var anim_player = $Body/AnimationPlayer
onready var effect_player = $Body/Effect_Player
onready var body = $Body
onready var cam = $Camera2D
onready var physics_shape =$PhysicsShape
onready var wall_slide_cooldown = $WallslideCooldown
onready var stick_to_wall_timer = $WallslideStick
onready var coyote_timer = $CoyoteTimer
onready var attach_pos = $AttachPosition

# onready var jump_sound = $SFX/jumpsound
# onready var hurt_sound = $SFX/hurtsound
# onready var dead_sound = $SFX/deadsound
# onready var vic_sound = $SFX/victory

var move_direction
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("killed",get_parent().get_node("Background/GUI"),"_on_Player_killed")
	connect("state_change",get_parent().get_node("Background/GUI"),"_on_Player_state_change")
	connect("victory",get_parent().get_node("Background/GUI"),"_on_Player_victory")
	connect("wall_slide_exited",get_parent().get_node("Background/GUI"),"_on_Player_wall_slide_exited")
	connect("wall_slide_state",get_parent().get_node("Background/GUI"),"_on_Player_wall_slide_state")
	pass # Replace with function body.

func _apply_movement(delta):
	var was_on_floor = is_on_floor()
	
	velocity = move_and_slide_with_snap(velocity,snap,UP)
	
	if !is_on_floor() and was_on_floor and !is_jumping:
		coyote_timer.start()
	is_grounded = is_on_floor()
	
func _apply_wall_stick():
	#snap = Vector2(wall_direction*32,0)
	velocity.x = wall_direction*1000
	
func _apply_gravity(delta):
	velocity.y +=gravity*delta
	if is_jumping and velocity.y >=0:
		is_jumping = false

func jump():
	is_jumping=true
	velocity.y = jump_velocity

func wall_jump():
	var wall_jump_velocity = WALL_JUMP_VELOCITY
	wall_jump_velocity.x *= -wall_direction
	velocity = wall_jump_velocity
	body.scale.x = -wall_direction 

func cut_jump():
	if velocity.y < -80:
		velocity.y = -80
	
func _handle_wall_slide_stickyness():
	if move_direction!=0 and move_direction != wall_direction:
		if stick_to_wall_timer.is_stopped():
			stick_to_wall_timer.start()
	else:
		stick_to_wall_timer.stop()

func _update_move_direction():
	move_direction = -Input.get_action_strength("left") + Input.get_action_strength("right")
	
func _handle_move_input():
	velocity.x = lerp(velocity.x,move_speed*move_direction,get_h_weight())
	if move_direction !=0:
		body.scale.x = move_direction
	#physics_shape.position.x = move_direction
		
		
func get_h_weight():
	if is_on_floor():
		return 0.15
	else:
		if move_direction == 0:
			return 0.02
		elif move_direction == sign(velocity.x) and abs(velocity.x) > move_speed:
			return 0.0
		else:
			return 0.1

func _cap_gravity_wall_slide():
	var max_velocity
	if !Input.is_action_pressed("down"):
		max_velocity = slide_velocity 
	else: 
		grabbing_shape.set_deferred("disabled",true)
		#print("grabbing_shape.disabled")
		max_velocity = 6*24
	velocity.y = min(velocity.y,max_velocity)
	
	
func _update_wall_direction():
	var is_near_wall_left = _check_is_valid_wall(left_raycast)
	var is_near_wall_right= _check_is_valid_wall(right_raycast)
	var edge_left = _check_there_is_an_edge(other_left_raycast)
	var edge_right = _check_there_is_an_edge(other_right_raycast)

	if edge_left or edge_right:
		is_on_edge = true
	else: is_on_edge = false
	if is_near_wall_left and is_near_wall_right:
		wall_direction = move_direction
	else:
		wall_direction = int(is_near_wall_left)-int(is_near_wall_right)
	
func _check_is_valid_wall(wall_raycast):
	for raycast in wall_raycast.get_children():
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("moving"):
				#moving wall
				
				
				stick_to_wall = false
				slide_velocity = 300
			else:
				
				slide_velocity = 0
				stick_to_wall = true
			#print(slide_velocity)
			return true
	return false
	
func _stick_to_moving_walls():
	var rc1 = sticky_leftcast
	var rc2 = sticky_rightcast
	var rc
	if rc1.is_colliding():
		rc = rc1
		
	elif rc2.is_colliding():
		rc = rc2
	else:
		return

	if rc.get_collider().is_in_group("moving"):
		attach_pos.global_position.y = rc.get_collider().global_position.y-7
		global_position.y = attach_pos.global_position.y
		moving_rightcast.set_deferred("enabled",true)
		moving_leftcast.set_deferred("enabled",true)

	else:
		print(rc.name)
		attach_pos.global_position.y = rc.get_collider().world_to_map(position).y*24+5
		global_position.y = attach_pos.global_position.y

func _check_there_is_an_edge(wall_raycast):
	if wall_raycast.is_colliding():
		return true
	else: return false

func die():
	if !has_won:
		velocity.x = 0
		var knockback_velocity = KNOCKBACK_VELOCITY
		knockback_velocity.x *= -wall_direction if !wall_direction !=0 else 1
		velocity = knockback_velocity
		body.scale.x = wall_direction if wall_direction!=0 else 1
		is_dead = true

func victory():
	velocity.x = 0
	is_dead=false
	has_won = true

func _on_AllowedGrabTimer_timeout():
	emit_signal("killed")

func _on_GUI_enable_camera():
	print("CAMERA ENABLED")
	cam.enable_camera = true


func _on_GUI_pause_camera():
	cam.enable_camera = false
