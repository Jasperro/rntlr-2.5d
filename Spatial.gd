extends Spatial
var camsetting = 3

func _process(delta):		
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_node("../pause_popup").set_exclusive(true)
		get_node("../pause_popup").popup()
		get_tree().set_pause(true)
	
	if (camsetting > 10 or camsetting < -3):
		camsetting = 3
		
	var playerx = get_node("../Player").get_global_transform().origin.x
	var playery = get_node("../Player").get_global_transform().origin.y
	set_translation(Vector3(playerx - 0.5,playery,camsetting))
	pass

func _on_unpause_pressed():
	get_node("../pause_popup").hide()
	get_tree().set_pause(false)

func _input(event):
	if (Input.is_key_pressed(KEY_MINUS)):
		camsetting = camsetting + 1
	elif (Input.is_key_pressed(KEY_PLUS) or Input.is_key_pressed(KEY_EQUAL)):
		camsetting = camsetting - 1