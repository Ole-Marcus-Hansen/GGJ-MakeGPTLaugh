extends Node

var player: Player
var has_submitted = false
var is_evaluating = false
var words = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if has_submitted and not is_evaluating:
		check_words_and_evaluate()
		has_submitted = true
		
	

func check_words_and_evaluate():
	# Check word blocks from map and then call APIManager
	
	APIManager.callGPT("")
	
	# Everything is done
	is_evaluating = true
