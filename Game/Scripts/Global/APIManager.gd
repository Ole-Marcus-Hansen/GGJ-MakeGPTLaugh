extends Node

signal completed(rating, comment)

@onready var http_request = HTTPRequest.new()

const url = "https://api.openai.com/v1/chat/completions"
const temperature = 0
const maxTokens = 128
const headers = ["Content-type: application/json", "Authorization: Bearer " + Secrets.key]
const model = "gpt-3.5-turbo"

@onready var prompt = """Rate the following sentence from 1 to 10 based on how funny it sounds. Rate them like you're a huge evil sarcastic robot with a weird sense of humour. The sentence will most likely not make sense so you will have to interpret it however you want. If the sentence is only one or two words you hate it. Be strict with the rating. Respond in JSON format {"rating": int, "comment": string}"""


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	# Test call
	# callGPT("why did the chicken cross the road? To get across")


func callGPT(input_joke):
	var messages = [
		{"role": "system",
		"content": prompt},
		{"role": "user",
		"content": input_joke}
	]
	
	var body = JSON.stringify({
		"messages": messages,
		"temperature": temperature,
		"max_tokens": maxTokens,
		"model": model
	})
	
	print(input_joke)
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	var message = response["choices"][0]["message"]["content"]
	print("message: " + message)
	
	#json.parse(message)
	#var message_split = json.get_data()
	
	var start_index = message.find("{")

	if start_index != -1:
		# Find the position of the last '}' character in the input string
		var end_index = message.rfind("}")

		if end_index != -1:
			# Extract the JSON string
			var json_string = message.substr(start_index, end_index - start_index + 1)

			# Parse the JSON string into a Dictionary
			if json.parse(json_string) == OK:
				var message_split = json.get_data()
				if message_split:
					#print("split: " + str(message_split["rating"]) + ", " + message_split["comment"])
					completed.emit(message_split["rating"], message_split["comment"])
					return
			else:
				print("Failed to parse JSON object")
		else:
			print("No closing '}' found in the input string")
	else:
		print("No opening '{' found in the input string")
	
	#print("split: " + str(message_split["rating"]) + ", " + message_split["comment"])
	completed.emit(10, "HAHAHA. The joke was so bad it almost made my program crash. Since it made me laugh you will get to keep going")
