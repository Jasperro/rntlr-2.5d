extends Button

func _on_Button_button_down():
	get_node("../CenterContainer/Loading").show()
	get_node("../CenterContainer/AnimatedSprite").hide()
	margin_top = -999
	margin_bottom = -999
	margin_left = -999
	margin_right = -999

func _on_Button_button_up():
	get_tree().change_scene("res://level1.tscn")
