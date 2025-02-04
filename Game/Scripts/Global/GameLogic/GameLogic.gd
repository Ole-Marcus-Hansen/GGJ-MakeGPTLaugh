extends Node

const TOTAL_ADJECTIVES = 3
const TOTAL_INTERROGATIVES = 1
const TOTAL_NOUNS = 3
const TOTAL_PRONOUNS = 1
const TOTAL_VERBS = 2
const TOTAL_WORDS = TOTAL_ADJECTIVES + TOTAL_INTERROGATIVES + TOTAL_NOUNS + \
	TOTAL_PRONOUNS + TOTAL_VERBS

var player: Player
var submit_area: Area3D
var screen: Screen
var has_submitted = false
var game_active = false
var target_rating = 1

@export var curve: Curve


func _ready():
	# Called when the node enters the scene tree for the first time.
	APIManager.completed.connect(interpret_gpt_feedback)
	#await get_tree().create_timer(1).timeout
	await get_tree().process_frame
	await get_tree().process_frame
	switch_to_main_menu()

func _input(event):
	if is_instance_valid(screen):
		screen.get_viewport().push_input(event)

func check_words_and_evaluate():
	# Check word blocks from map and then call APIManager
	
	if has_submitted:
		return
	
	has_submitted = true
	
	var bodies = submit_area.get_overlapping_bodies()
	var cubes = []
	for body in bodies:
		if body is Cube:
			cubes.append(body)
			
	cubes.sort_custom(sort_cubes)
	
	var input_joke: String = ""
	for cube in cubes:
		input_joke += cube.word + " "
		cube.remove()
		
	input_joke = input_joke.left(-1)
	
	if input_joke.is_empty():
		has_submitted = false
		return
	
	screen.display_processing()
	APIManager.callGPT(input_joke)


func clear_map():
	# Remove all cubes
	var cubes = get_tree().get_nodes_in_group("cubes")
	for cube in cubes:
		cube.queue_free()


func interpret_gpt_feedback(rating: int, comment: String):
	# Interpret the feedback from Chat GPT and make things happen in the game
	
	await screen.display_comment(comment)
	await screen.display_rating(rating)
	
	if rating < target_rating:
		# Game Over
		await screen.display_angry()
		player.die()
		return
	
	await screen.display_happy()
	
	reset_map()


func play_game():
	# Called when game starts
	
	game_active = true
	await screen.display_make_me_laugh()
	var player_camera: Camera3D = player.CAMERA
	player_camera.make_current()
	reset_map()


func reset_map():
	# Set or reset map to default
	
	has_submitted = false
	set_target_rating()
	await screen.display_required_rating(target_rating)
	
	var cubes = get_tree().get_nodes_in_group("cubes")
	var num_remaining_cubes = len(cubes)
	
	var remaining_adjectives = 0
	var remaining_interrogatives = 0
	var remaining_nouns = 0
	var remaining_pronouns = 0
	var remaining_verbs = 0
	
	for cube in cubes:
		
		if not cube is Cube:
			continue
		
		if cube.word_class == "adjectives":
			remaining_adjectives +=1
		elif cube.word_class == "interrogatives":
			remaining_interrogatives += 1
		elif cube.word_class == "nouns":
			remaining_nouns += 1
		elif cube.word_class == "pronouns":
			remaining_pronouns += 1
		elif cube.word_class == "verbs":
			remaining_verbs += 1
	
	var required_adjectives = TOTAL_ADJECTIVES - remaining_adjectives
	var required_interrogatives = TOTAL_INTERROGATIVES - remaining_interrogatives
	var required_nouns = TOTAL_NOUNS - remaining_nouns
	var required_pronouns = TOTAL_PRONOUNS - remaining_pronouns
	var required_verbs = TOTAL_VERBS - remaining_verbs
	
	
	var word_lists: Dictionary = FileManager.pick_words(required_nouns, 
		required_verbs, required_adjectives, required_pronouns, 
		required_interrogatives)
	
	
	spawn_cubes(word_lists)


func set_target_rating():
	# Set target rating player must achieve to survive
	
	var rng = RandomNumberGenerator.new()
	var randfloat = rng.randf_range(0, 1)
	var curve_y = curve.sample(randfloat)	
	target_rating = floori(curve_y * 10)


func sort_cubes(cube_1: Cube, cube_2: Cube):
	# Sort cubes by position
	
	var posz_1 = cube_1.global_position.z
	var posz_2 = cube_2.global_position.z
	
	return posz_1 > posz_2


func spawn_cubes(word_lists):
	# Prepere words and spawn cubes
	
	var spawners = get_tree().get_nodes_in_group("spawners")	
	if spawners.is_empty():
		return
		

	var index = 0
	for word_class in word_lists:
		
		var color: Color = word_lists[word_class]["color"]
		
		for word in word_lists[word_class]["words"]:
			
			await get_tree().create_timer(0.3).timeout
			
			if index == len(spawners):
				index = 0
				
			var spawner: Spawner = spawners[index]
			spawner.spawn(word, word_class, color)
			index += 1


func switch_to_main_menu():
	game_active = false
	var main_screen_camera: Camera3D = get_tree().current_scene.get_node("Camera3D")
	main_screen_camera.make_current()
	screen.display_main_menu()
