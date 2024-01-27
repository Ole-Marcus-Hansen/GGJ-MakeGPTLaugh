#@tool
#extends EditorScript
extends Node

const TOTAL_NUM_WORDS = 10
const ADJECTIVES_FILE = "res://Game/Text/adjectives.txt"
const INTERROGATIVES_FILE = "res://Game/Text/interrogative.txt"
const NOUNS_FILE = "res://Game/Text/nouns.txt"
const PRONOUNS_FILE = "res://Game/Text/pronouns.txt"
const VERBS_FILE = "res://Game/Text/verbs.txt"

var word_lists: Dictionary = {
	"adjectives": {
		"num_lines": 0,
		"words": []
		},
	"interrogatives": {
		"num_lines": 0,
		"words": []
		},
	"nouns": {
		"num_lines": 0,
		"words": []
		},
	"pronouns": {
		"num_lines": 0,
		"words": []
		},
	"verbs": {
		"num_lines": 0,
		"words": []
		}	
}

var word_selection_lists: Dictionary = {
	"adjectives": {
		"color": Color.ORANGE,
		"words": []
		},
	"interrogatives": {
		"color": Color.YELLOW,
		"words": []
		},
	"nouns": {
		"color": Color.BLUE,
		"words": []
		},
	"pronouns": {
		"color": Color.GREEN,
		"words": []
		},
	"verbs": {
		"color": Color.RED,
		"words": []
		}	
}


func _run():
	var words = pick_words(3, 4, 2, 1, 1)
	print()
	for i in len(words):
		print(words[i])
	print()


func _ready():
	get_all_words()
	
	
func get_all_words():
	# Get all words from word list files
	
	for word_class in word_lists:
		word_lists[word_class]["num_lines"] = 0
		word_lists[word_class]["words"].clear()
	
	var file = FileAccess.open(NOUNS_FILE, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		if line == "" or line == "\n" or line == null:
			continue
		word_lists["nouns"]["num_lines"] += 1
		word_lists["nouns"]["words"].append(line)
	file.close()
		
	file = FileAccess.open(VERBS_FILE, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		if line == "" or line == "\n" or line == null:
			continue
		word_lists["verbs"]["num_lines"] += 1
		word_lists["verbs"]["words"].append(line)
	file.close()
		
	file = FileAccess.open(ADJECTIVES_FILE, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		if line == "" or line == "\n" or line == null:
			continue
		word_lists["adjectives"]["num_lines"] += 1
		word_lists["adjectives"]["words"].append(line)
	file.close()
		
	file = FileAccess.open(PRONOUNS_FILE, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		if line == "" or line == "\n" or line == null:
			continue
		word_lists["pronouns"]["num_lines"] += 1
		word_lists["pronouns"]["words"].append(line)
	file.close()
		
	file = FileAccess.open(INTERROGATIVES_FILE, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		if line == "" or line == "\n" or line == null:
			continue
		word_lists["interrogatives"]["num_lines"] += 1
		word_lists["interrogatives"]["words"].append(line)
	file.close()


func pick_words(nouns: int, verbs: int, adjectives: int, pronouns: int, 
	interrogatives: int):
	# Pick a certain amount of random words from word list file
	
	for word_class in word_selection_lists:
		# Clear words from dictionary
		word_selection_lists[word_class]["words"].clear()
	
	for word_class in word_lists:
		# If data is missing for any reason, reset word list dictionary
		var num_lines = word_lists[word_class]["num_lines"]
		var word_array = word_lists[word_class]["words"]
		if num_lines != 0 or word_array.is_empty():
			get_all_words()
			break 
		
	var rng = RandomNumberGenerator.new()
	
	for word_class in word_lists:
		
		var num_words_to_select = 0
		if word_class == "adjectives":
			num_words_to_select = adjectives
		elif word_class == "interrogatives":
			num_words_to_select = interrogatives
			print(word_lists[word_class]["words"])
		elif word_class == "nouns":
			num_words_to_select = nouns
		elif word_class == "pronouns":
			num_words_to_select = pronouns
		elif word_class == "verbs":
			num_words_to_select = verbs
		
		for i in num_words_to_select:
			var num_lines = word_lists[word_class]["num_lines"]
			var randint = rng.randi_range(0, num_lines - 1)
			var word_array = word_lists[word_class]["words"]
			var chosen_word = word_array[randint]
			word_selection_lists[word_class]["words"].append(chosen_word)
		
	return word_selection_lists	
