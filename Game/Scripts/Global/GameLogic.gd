extends Node

var player: Player
var submit_area: Area3D
var has_submitted = false
var is_evaluating = false
var words = []

# Called when the node enters the scene tree for the first time.
func _ready():
	APIManager.completed.connect(interpret_gpt_feedback)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if has_submitted and not is_evaluating:
		check_words_and_evaluate()
		has_submitted = true
		
	

func check_words_and_evaluate():
	# Check word blocks from map and then call APIManager
	
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
	
	# To do:
	# 1. Refer to labels on the TV screen to write rating and comment
	# 2. Happy or angry face
	# 3. Laugh-o-meter???
	# 4. Handle game over or next level
	pass
	

func sort_cubes(cube_1: Cube, cube_2: Cube):
	# Sort cubes by position
	
	var posz_1 = cube_1.global_position.z
	var posz_2 = cube_2.global_position.z
	
	return posz_1 > posz_2
