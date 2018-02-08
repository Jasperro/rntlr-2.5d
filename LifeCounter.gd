extends Label

func _process(delta):
	set_text(String(get_node("../Player").get("lifes")))
	pass