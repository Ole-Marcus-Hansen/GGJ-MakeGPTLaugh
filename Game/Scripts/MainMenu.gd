extends Node2D


func display() -> void:
	show()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN



func _process(_delta):
	if GameLogic.game_active: return
	%Mouse.position = get_tree().root.get_mouse_position() * Vector2(get_viewport().size) / Vector2(get_tree().root.size)


func _input(event):
	if GameLogic.game_active: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			click()

func click() -> void:
	if %Mouse.overlaps_area(%Play):
		GameLogic.play_game()
		hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#elif %Mouse.overlaps_area(%Play): quit()




