extends CharacterBody3D
class_name Cube



func push(direction: Vector3) -> void:
	velocity = direction
	move_and_slide()






