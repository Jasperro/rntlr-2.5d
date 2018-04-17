extends Spatial
var camsetting = 5

func _physics_process(delta):
	if (Input.is_action_pressed("pause")):
		get_node("../UI/pause_popup").set_exclusive(true)
		get_node("../UI/pause_popup").popup()
		get_tree().set_pause(true)
	
	if (camsetting > 12 or camsetting < -1):
		camsetting = 5
		
	var playerx = get_node("../Player").get_global_transform().origin.x
	var playery = get_node("../Player").get_global_transform().origin.y
	set_translation(Vector3(playerx - 0.5,playery + 1,camsetting))
	pass

func _on_unpause_pressed():
	get_node("../UI/pause_popup").hide()
	get_tree().set_pause(false)

func _input(event):
	if (Input.is_key_pressed(KEY_MINUS)):
		camsetting = camsetting + 1
	elif (Input.is_key_pressed(KEY_PLUS) or Input.is_key_pressed(KEY_EQUAL)):
		camsetting = camsetting - 1

func _on_quit_pressed():
	get_tree().quit()