extends Node

signal completed(rating, comment)

@onready var http_request = HTTPRequest.new()

const url = "https://api.openai.com/v1/chat/completions"
const temperature = 0
const maxTokens = 128
const headers = ["Content-type: application/json", "Authorization: Bearer " + Secrets.key]
const model = "gpt-3.5-turbo"

@onready var prompt = """Rate the following joke from 1 to 10. 1-3 is not funny, 4-7 is somewhat almost funny and 8-10 is actually kinda funny. You are a huge evil robot who doesn't fully understand how jokes work. If the joke is incomplete or nonsensible, rate it nonetheless like you think it's a joke. Respond in JSON format {"rating": int, "comment": string}"""


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
	
	json.parse(message)
	var message_split = json.get_data()
	
	#print("split: " + str(message_split["rating"]) + ", " + message_split["comment"])
	
	completed.emit(message_split["rating"], message_split["comment"])
