extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameLogic.submit_area = self
