extends KinematicBody
var orientation = 1

func _process(delta):
	if get_global_transform().origin.x <= -1:
		orientation = 1
		rotate_y(PI)
	elif get_global_transform().origin.x >= 5:
		orientation = 2
		rotate_y(PI)
	
	if orientation == 1:
		move_and_slide(Vector3(2,0,0))
	elif orientation == 2:
		move_and_slide(Vector3(-2,0,0))