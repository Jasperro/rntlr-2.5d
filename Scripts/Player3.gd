extends KinematicBody

var g = -10
var vel = Vector3()
var lives = 800
var dir
const MAX_SPEED = 5
const MAX_RUN_SPEED = 9
const JUMP_SPEED = 7
const ACCEL= 2
const DEACCEL= 20
const MAX_SLOPE_ANGLE = 30

#Shooting Variables
var shootAnimator;
var shootTimeout; 
var isShooting; 
var shootRaycast;

func _ready():
	shootTimeout = 0.0;
	isShooting = false; 
	
	shootRaycast = self.get_node("CollisionShape/RayCast");
	print(shootRaycast.transform.origin);
	get_node("FlyingCamera/Camera").make_current()

func _physics_process(delta):
	var dir = Vector3()
	var cam_xform = get_node("./FlyingCamera").get_global_transform()
	var cam_rotation = get_node("./FlyingCamera").rotation_degrees
	
	if (Input.is_action_pressed("ui_left")):
		dir += -cam_xform.basis[0]
		print(cam_xform)
		if get_node("./AnimationPlayer").is_playing() == false:
			get_node("./AnimationPlayer").play("default")
			if Input.is_action_pressed("fp"):
				get_node("./CollisionShape").rotation_degrees = Vector3(0,cam_rotation.y+90,0)
			else:
				get_node("./CollisionShape").rotation_degrees = Vector3(0,cam_rotation.y-180,0)
	elif (Input.is_action_pressed("ui_right")):
		dir += cam_xform.basis[0]
		if get_node("./AnimationPlayer").is_playing() == false:
			get_node("./AnimationPlayer").play("default")
			if Input.is_action_pressed("fp"):
				get_node("./CollisionShape").rotation_degrees = Vector3(0,cam_rotation.y+90,0)
			else:
				get_node("./CollisionShape").rotation_degrees = Vector3(0,cam_rotation.y,0)
	elif (Input.is_action_pressed("ui_up")):
		dir += -cam_xform.basis[2]
		if get_node("./AnimationPlayer").is_playing() == false:
			get_node("./AnimationPlayer").play("default")
		get_node("./CollisionShape").rotation_degrees = Vector3(0,cam_rotation.y+90,0)
	elif (Input.is_action_pressed("ui_down")):
		dir += cam_xform.basis[2]
		if get_node("./AnimationPlayer").is_playing() == false:
			get_node("./AnimationPlayer").play("default")
		if Input.is_action_pressed("fp"):
			get_node("./CollisionShape").rotation_degrees = Vector3(0,cam_rotation.y+90,0)
		else:
			get_node("./CollisionShape").rotation_degrees = Vector3(0,cam_rotation.y-90,0)
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
		get_tree().change_scene("res://Scenes/titlescreen.tscn")
	#if get_global_transform().origin.z < 0 or get_global_transform().origin.z > 0:
	#	set_translation(Vector3(get_global_transform().origin.x,get_global_transform().origin.y,0))
		
		
	#Shooting Logic!
	if(shootTimeout > 0.0):
		shootTimeout -= delta;

	if(shootTimeout <= 0.0 && isShooting):
		weaponShoot();
			
func weaponShoot():
	if(!isShooting):
		return; 
		
	shootTimeout = 0.1;
	#shootAnimator.play("FIRE"); 
	
	if(shootRaycast.is_colliding()):
		var shootObject = shootRaycast.get_collider() ; 
		#print(shootObject.tag)
		if(shootObject.get("tag")):
			print("Pew!");
			shootObject.queue_free()
		else:
			print("Missed!")
			
func _on_Area_body_entered(body):
	vel.y = JUMP_SPEED*2
	
func _input(event):
	if(Input.is_action_pressed("shoot") && !isShooting):
			isShooting = true ;
			
	if(!Input.is_action_pressed("shoot") && isShooting):
			isShooting = false;
	
	if Input.is_action_pressed("fp"):
		get_node("FirstPersonCamera/Camera").make_current()
		get_node("../UI/Crosshair").show()
		hide()
		shootRaycast = self.get_node("FirstPersonCamera/Camera/RayCast");
	else:
		get_node("FlyingCamera/Camera").make_current()
		get_node("../UI/Crosshair").hide()
		show()
		shootRaycast = self.get_node("CollisionShape/RayCast");
	#	var magic = preload("res://Scenes/magic.tscn").instance()
	#	get_parent().add_child(magic)
