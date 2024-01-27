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
var has_submitted = false
var is_evaluating = false
var target_rating = 1

@export var curve: Curve

# Called when the node enters the scene tree for the first time.
func _ready():
	APIManager.completed.connect(interpret_gpt_feedback)
	await get_tree().create_timer(1).timeout
	reset_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if has_submitted and not is_evaluating:
		check_words_and_evaluate()
		has_submitted = true
		
	

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
		
	input_joke = input_joke.left(-1)	
	
	APIManager.callGPT(input_joke)

	
func interpret_gpt_feedback(rating: int, comment: String):
	# Interpret the feedback from Chat GPT and make things happen in the game
	
	
	
	if rating < target_rating:
		# Game Over
		print("you lost")
		return
	
	reset_map()
	# To do:
	# 1. Refer to labels on the TV screen to write rating and comment
	# 2. Happy or angry face
	# 3. Laugh-o-meter???
	# 4. Handle game over or next level
	pass
	
	
func reset_map():
	# Set or reset map to default
	
	set_target_rating()
	
	var cubes = get_tree().get_nodes_in_group("cubes")
	var num_remaining_cubes = len(cubes)
	print("remaining cubes: " + str(num_remaining_cubes))
	
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
	
	print("adj" + str(required_adjectives))
	
	var word_lists: Dictionary = FileManager.pick_words(required_nouns, 
		required_verbs, required_adjectives, required_pronouns, 
		required_interrogatives)
	
	print(word_lists)
	
	spawn_cubes(word_lists)
	
	
func set_target_rating():
	# Set target rating player must achieve to survive
	
	var rng = RandomNumberGenerator.new()
	var randfloat = rng.randf_range(0.1, 0.999)
	var curve_y = curve.sample(randfloat)	
	target_rating = floori(curve_y * 10)
	print("target rating: " + str(target_rating))

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
		
	print("test")
	var index = 0
	for word_class in word_lists:
		
		var color: Color = word_lists[word_class]["color"]
		
		for word in word_lists[word_class]["words"]:
			
			await get_tree().create_timer(0.3).timeout
			
			if index == len(spawners):
				index = 0
				
			var spawner: Spawner = spawners[index]
			spawner.spawn(word, word_class, color)
			print("spawning: " + word)
			index += 1
