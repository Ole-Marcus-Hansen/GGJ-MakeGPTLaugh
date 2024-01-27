@tool
extends CharacterBody3D
class_name Cube

@export var word := "":
	set(x):
		word = x
		%Label.text = x.to_upper()

@export var gravity: float = 100
@export var friction: float = 100


var spawned := false

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
	if spawned: $Hitbox.disabled = true
	%Mesh.mesh.material.albedo_texture = %Viewport.get_texture()
	if Engine.is_editor_hint(): return
	add_to_group("cubes")



func play_spawn_animation(pos: Vector3, upward_force: float) -> void:
	%Mesh.scale = Vector3.ZERO
	
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	tween.tween_property(%Mesh, ^"scale", Vector3.ONE, .5)
	tween.tween_property(self, ^"global_position:x", pos.x, 1).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, ^"global_position:z", pos.z, 1).set_trans(Tween.TRANS_QUAD)
	
	velocity.y = upward_force
	
	await tween.finished
	$Hitbox.disabled = false
	

