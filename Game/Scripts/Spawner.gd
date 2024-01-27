extends Marker3D
class_name Spawner


@export var upward_force: float = 100
@export var cube_scene: PackedScene

var spawn_locations: Array[SpawnPosition]
var location_pool: Array[SpawnPosition]


func spawn(text: String, word_class: String, colour := Color.BLACK) -> void:
	if location_pool.is_empty():
		location_pool = spawn_locations.duplicate()
	
	if location_pool.is_empty(): return
	
	var destination: SpawnPosition = location_pool.pick_random()
	
	location_pool.erase(destination)
	
	var cube := cube_scene.instantiate() as Cube
	cube.word = text
	cube.word_class = word_class
	cube.spawned = true
	cube.set_colour(colour)
	add_child(cube)
	cube.global_position = global_position
	cube.play_spawn_animation(destination.global_position, upward_force)






func _ready() -> void:
	add_to_group("spawners")
	
	for c in get_children():
		if c is SpawnPosition:
			spawn_locations.append(c)








