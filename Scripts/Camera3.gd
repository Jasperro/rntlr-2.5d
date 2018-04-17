extends Spatial

export(float) var mouse_sensitivity = 0.0004
export(float) var camera_speed = 0.2

const X_AXIS = Vector3(1, 0, 0)
const Y_AXIS = Vector3(0, 1, 0)
const Z_AXIS = Vector3(0, 0, 1)

var is_mouse_motion = false

var mouse_speed = Vector2()
var mouse_speed_x = 0
var mouse_speed_y = 0

var rot_x = Quat()
var rot_y = Quat()

onready var camera_transform = self.get_transform()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if (is_mouse_motion):
		mouse_speed = Input.get_last_mouse_speed()
		is_mouse_motion = false
		mouse_speed_x += mouse_speed.x * mouse_sensitivity
		mouse_speed_y += mouse_speed.y * mouse_sensitivity
		var rot_x = Quat(X_AXIS, -mouse_speed_y)
		var rot_y = Quat(Y_AXIS, -mouse_speed_x)
		self.set_transform(camera_transform * Transform(rot_y) * Transform(rot_x))
		translation = Vector3(0,4.8,0)
func _input(event):
	if (event is InputEventMouseMotion):
		is_mouse_motion = true