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
	var dir = Vector3()
	var cam_xform = get_node("../Camera2").get_global_transform()
	
	if (Input.is_action_pressed("ui_left")):
		dir += -cam_xform.basis[0]
		if get_node("./AnimationPlayer").is_playing() == false:
			get_node("./AnimationPlayer").play("default")
		projdir = -0.4
		rotation_degrees = Vector3(0,-90,0)
	elif (Input.is_action_pressed("ui_right")):
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
	
	if (dir.dot(hvel) > 0 and Input.is_action_pressed("sprint")):
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
	
	if (is_on_floor() and Input.is_action_pressed("jump")):
		vel.y = JUMP_SPEED

	if (Input.is_action_pressed("fly")):
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
	if Input.is_action_pressed("shoot"):
		var magic = preload("res://magic.tscn").instance()
		magic.translation = Vector3(get_global_transform().origin.x + projdir,  get_global_transform().origin.y + 0.3, 0)
		magic.linear_velocity = Vector3(projdir * 6, 0.5, 0)
		get_parent().add_child(magic)


func _on_LeftTouchButton_pressed():
	print("left")

func _on_RightTouchButton_pressed():
	print("right")

func _on_SprintTouchButton_pressed():
	print("sprint")

func _on_JumpTouchButton_pressed():
	print("jump")
