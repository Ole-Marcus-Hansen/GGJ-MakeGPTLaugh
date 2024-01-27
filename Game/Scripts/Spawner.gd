class_name Spawner extends Marker3D

@export var cube_scene: PackedScene



func spawn(text: String, word_class: String, colour := Color.BLACK) -> void:
	var cube := cube_scene.instantiate() as Cube
	cube.word = text
	cube.word_class = word_class
	cube.set_colour(colour)
	add_child(cube)
	cube.global_position = global_position
	cube.play_spawn_animation(Vector3.ZERO)









