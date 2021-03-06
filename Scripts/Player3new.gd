extends KinematicBody

const MAX_SLOPE_ANGLE = 45;

var g_Time = 0.0;
var cam = null;

var view_sensitivity = 0.2;
var focus_view_sensv = 0.1;
var walk_speed = 2.2;
var run_multiplier = 2.0;
var move_speed = walk_speed;
var JUMP_SPEED = 7;
var g = -10;
var acceleration = 4;
var deacceleration = 10;

var velocity = Vector3();
var is_moving = false;
var on_floor = false;

var focus_switchtime = 0.0;
var focus_mode = false;
var focus_right = true;

func _ready():
	cam = get_node("FloatingCamera/Camera");
	
	#cam.add_collision_exception(self)
	#cam.cam_radius = 2.5;
	#cam.cam_view_sensitivity = view_sensitivity;
	#cam.cam_smooth_movement = true;

func _input(ie):
	if ie.type == InputEvent.MOUSE_BUTTON:
		if ie.pressed && ie.button_index == BUTTON_RIGHT && g_Time > focus_switchtime:
			focus_mode = !focus_mode;
			focus_switchtime = g_Time + 0.2;
			
			if focus_mode:
				cam.cam_fov = 45.0;
				cam.cam_pitch_minmax = Vector2(30, -10);
				cam.cam_view_sensitivity = focus_view_sensv;
				
			else:
				cam.cam_fov = 80.0;
				cam.cam_pitch_minmax = Vector2(80, -60);
				cam.cam_view_sensitivity = view_sensitivity;
		
	if ie.type == InputEvent.KEY:
		if ie.pressed && Input.is_key_pressed(KEY_F1):
			OS.set_window_fullscreen(!OS.is_window_fullscreen());
		
		if ie.pressed && Input.is_key_pressed(KEY_ESCAPE):
			get_tree().call_deferred("quit");

func _physics_process(delta):
	g_Time += delta;
	
	#var overview_map = get_node("/root/main/gui/map_overview");
	#overview_map.player_pos = Vector2(get_global_transform().origin.x, get_global_transform().origin.z);
	#overview_map.player_rot = deg2rad(cam.cam_cyaw);
	check_movement(delta);
	player_on_fixedprocess(delta);

func check_movement(delta):
	var aim = get_global_transform().basis;
	
	if on_floor:
		g = 0;
		if !is_moving:
			velocity.y = 0;
		if velocity.length() < 0.01:
			velocity = Vector3();
	
	is_moving = false;
	var direction = Vector3();
	
	if Input.is_key_pressed(KEY_W):
		is_moving = true;
		direction -= aim[2];
		
		if Input.is_key_pressed(KEY_A) && focus_mode:
			direction -= aim[0];
		if Input.is_key_pressed(KEY_D) && focus_mode:
			direction += aim[0];
	elif Input.is_key_pressed(KEY_S):
		is_moving = true;
		
		if focus_mode:
			direction += aim[2];
		else:
			direction -= aim[2];
		
		if Input.is_key_pressed(KEY_A) && focus_mode:
			direction -= aim[0];
		if Input.is_key_pressed(KEY_D) && focus_mode:
			direction += aim[0];
	elif Input.is_key_pressed(KEY_A):
		is_moving = true;
		
		if focus_mode:
			direction -= aim[0];
		else:
			direction -= aim[2];
	elif Input.is_key_pressed(KEY_D):
		is_moving = true;
		
		if focus_mode:
			direction += aim[0];
		else:
			direction -= aim[2];
	
	direction.y = 0;
	direction = direction.normalized()
	
	velocity.y += g*delta;
	
	var hvel = velocity;
	hvel.y = 0;
	
	var target = direction*move_speed;
	var accel = deacceleration;
	
	if direction.dot(hvel) > 0:
		accel = acceleration;
	
	hvel = target;
	#hvel = hvel.linear_interpolate(target,accel*delta);
	velocity.x = hvel.x;
	velocity.z = hvel.z;
	
	var motion = velocity*delta;
	motion = move(motion);
	
	var original_vel = velocity;
	var attempts=4;
	
	if motion.length() > 0:
		while is_colliding() && attempts:
			var n = get_collision_normal();
		
			if (rad2deg(acos(n.dot(Vector3(0,1,0))))< MAX_SLOPE_ANGLE):
				on_floor = true;
			
			motion=n.slide(motion);
			velocity=n.slide(velocity);
			
			if original_vel.dot(velocity) > 0:
				motion=move(motion);
				if motion.length() < 0.001:
					break;
			
			attempts-=1;
	
	if on_floor and Input.is_key_pressed(KEY_SPACE):
		velocity.y = JUMP_SPEED;
		on_floor = false;

func player_on_fixedprocess(delta):
	if Input.is_key_pressed(KEY_SHIFT) && is_moving && !focus_mode:
		move_speed = max(min(move_speed+(4*delta),walk_speed*2.0),walk_speed);
	else:
		move_speed = max(min(move_speed-(4*delta),walk_speed*2.0),walk_speed);
	
	var tmp_Camerayaw = cam.cam_yaw;
	if is_moving && !focus_mode:
		if Input.is_key_pressed(KEY_W):
			if Input.is_key_pressed(KEY_A):
				tmp_Camerayaw += 45;
			if Input.is_key_pressed(KEY_D):
				tmp_Camerayaw -= 45;
		elif Input.is_key_pressed(KEY_S):
			if Input.is_key_pressed(KEY_A):
				tmp_Camerayaw += 135;
			elif Input.is_key_pressed(KEY_D):
				tmp_Camerayaw -= 135;
			else:
				tmp_Camerayaw -= 180;
		elif Input.is_key_pressed(KEY_A):
			tmp_Camerayaw += 90;
		elif Input.is_key_pressed(KEY_D):
			tmp_Camerayaw -= 90;
	
	if is_moving || focus_mode:
		var body_rot = get_node("body").get_rotation();
		body_rot.y = deg2rad(lerp(rad2deg(body_rot.y),tmp_Camerayaw,10));
		#body_rot.y = deg2rad(tmp_Camerayaw);
		get_node("body").set_rotation(body_rot);
	
	if is_moving:
		var speed = (move_speed/walk_speed);
		get_node("AnimationPlayer").set_anim("default", speed);
	else:
		get_node("AnimationPlayer").set_anim("default");

func set_anim(name, speed = 1.0):
	var animplayer = get_node("AnimationPlayer");
	animplayer.set_speed(speed);
	var current = animplayer.get_current_animation();
	if current != name:
		animplayer.play("default");
