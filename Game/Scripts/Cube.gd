@tool
extends CharacterBody3D
class_name Cube

var word_class: String = ""

@export var word := "":
	set(x):
		word = x
		%Label.text = x.to_upper()

@export var gravity: float = 100
@export var friction: float = 100



func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if is_instance_valid(GameLogic.player) and %Area.overlaps_body(GameLogic.player):
		var dir: Vector3 = GameLogic.player.global_position.direction_to(global_position)
		dir.y = 0
		
		if absf(dir.x) > absf(dir.z): dir.z = 0
		else: dir.x = 0
		
		for i in 3:
			if dir[i] * GameLogic.player.velocity[i] > 0:
				if absf(GameLogic.player.velocity[i]) > absf(velocity[i]):
					velocity[i] = GameLogic.player.velocity[i]
				break
	
	if not is_on_floor():
		velocity.y -= gravity
	
	move_and_slide()
	velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
	


func set_colour(colour: Color) -> void:
	%Colour.color = colour


func _ready() -> void:
	add_to_group("cubes")
	%Mesh.mesh.material.albedo_texture = %Viewport.get_texture()

func play_spawn_animation(pos: Vector3) -> void:
	%Mesh.scale = Vector3.ZERO
	
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(%Mesh, ^"scale", Vector3.ONE, 1)
	#tween.tween_property(self, ^"scale", Vector3.ONE, 1)

