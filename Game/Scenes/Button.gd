extends Node3D


func _on__body_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Player:
		GameLogic.check_words_and_evaluate()
		($PressurePlate as AnimatableBody3D).translate(Vector3(0, -0.2, 0))


func _on_body_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is Player:
		($PressurePlate as AnimatableBody3D).translate(Vector3(0, 0.2, 0))
