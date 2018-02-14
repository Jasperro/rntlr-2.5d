extends KinematicBody

var g = -10
var vel = Vector3()
var lives = 3
var projdir = 0.4
const MAX_SPEED = 5
const MAX_RUN_SPEED = 9
const JUMP_SPEED = 7
const ACCEL= 2
const DEACCEL= 20
const MAX_SLOPE_ANGLE = 30

func _physics_process(delta):
	var dir = Vector3() # Where does the player intend to walk to
	var cam_xform = get_node("../Camera2").get_global_transform()
	
	if (Input.is_key_pressed(65) or Input.is_key_pressed(KEY_LEFT)):
		dir += -cam_xform.basis[0]
		if get_node("./AnimationPlayer").is_playing() == false:
			get_node("./AnimationPlayer").play("default")
		projdir = -0.4
		rotation_degrees = Vector3(0,-90,0)
	elif (Input.is_key_pressed(68) or Input.is_key_pressed(KEY_RIGHT)):
		dir += cam_xform.basis[0]
		if get_node("./AnimationPlayer").is_playing() == false:
			get_node("./AnimationPlayer").play("default")
		projdir = 0.4
		rotation_degrees = Vector3(0,90,0)
	else:
		get_node("./AnimationPlayer").stop(true)
	
	dir.y = 0
	dir = dir.normalized()
	
	vel.y += delta*g
	
	var hvel = vel
	hvel.y = 0

	var accel
	var target = dir*MAX_SPEED
	if (dir.dot(hvel) > 0 and Input.is_key_pressed(KEY_SHIFT)):
		accel = ACCEL
		target = dir*MAX_RUN_SPEED
		get_node("./AnimationPlayer").playback_speed=3.0
	elif (dir.dot(hvel) > 0):
		accel = ACCEL
		target = dir*MAX_SPEED
		get_node("./AnimationPlayer").playback_speed=1.0
	else:
		accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel*delta)
	
	vel.x = hvel.x
	vel.z = hvel.z
	
	vel = move_and_slide(vel,Vector3(0,1,0))
	
	if (is_on_floor() and Input.is_key_pressed(32) or is_on_floor() and Input.is_key_pressed(KEY_UP) or is_on_floor() and Input.is_key_pressed(KEY_W)):
		vel.y = JUMP_SPEED
		
	if (Input.is_key_pressed(70)):
		vel.y = JUMP_SPEED
		
	if get_global_transform().origin.y < 0:
		set_translation(Vector3(0,1,0))
		lives = lives - 1
	
	if lives == 0:
		set_translation(Vector3(0,1,0))
		lives = 3
		print("YOU DIED")
		get_tree().change_scene("res://titlescreen.tscn")
	
	if get_global_transform().origin.z < 0 or get_global_transform().origin.z > 0:
		set_translation(Vector3(get_global_transform().origin.x,get_global_transform().origin.y,0))
	
func _on_Area_body_entered(body):
	vel.y = JUMP_SPEED*2
	
func _input(event):
	if Input.is_key_pressed(KEY_M):
		var magic = preload("res://magic.tscn").instance()
		magic.translation = Vector3(get_global_transform().origin.x + projdir,  get_global_transform().origin.y + 0.3, 0)
		magic.linear_velocity = Vector3(projdir * 6, 0.5, 0)
		get_parent().add_child(magic)
