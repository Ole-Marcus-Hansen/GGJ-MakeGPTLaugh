extends Node2D


func display() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN



func _process(delta):
	if GameLogic.game_active: return
	%Mouse.global_position = get_global_mouse_position()
	








