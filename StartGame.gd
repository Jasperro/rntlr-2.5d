extends Button
var ready
func _on_Button_pressed():
	ready = 1
	get_node("../Container/Loading").show()
	get_node("../Container/Logo").hide()
func _gui_input(event):
	if ready == 1:
		get_tree().change_scene("res://level1.tscn")