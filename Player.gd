extends KinematicBody

var g = -10
var vel = Vector3()
var lifes = 3
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
		get_node("./Sprite3D").set_flip_h(true)
		get_node("./Sprite3D").set_animation("walking")
	elif (Input.is_key_pressed(68) or Input.is_key_pressed(KEY_RIGHT)):
		dir += cam_xform.basis[0]
		get_node("./Sprite3D").set_flip_h(false)
		get_node("./Sprite3D").set_animation("walking")
	else:
		get_node("./Sprite3D").set_animation("idle")
	
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
	elif (dir.dot(hvel) > 0):
		accel = ACCEL
		target = dir*MAX_SPEED
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
		lifes = lifes - 1
	
	if lifes == 0:
		set_translation(Vector3(0,1,0))
		lifes = 3
		print("YOU DIED")
	
	var playerx = get_global_transform().origin.x
	var playery = get_global_transform().origin.y
	var playerz = get_global_transform().origin.z
	if playerz < 0 or playerz > 0:
		set_translation(Vector3(playerx,playery,0))