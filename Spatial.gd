extends Spatial

func _process(delta):
	var playerx = get_node("../Player").get_global_transform().origin.x
	var playery = get_node("../Player").get_global_transform().origin.y
	set_translation(Vector3(playerx - 0.5,playery,1.05))
	pass