@tool
extends CharacterBody3D
class_name Cube

@export var word := "":
	set(x):
		word = x
		%Label.text = x.to_upper()

@export var gravity: float = 100
@export var friction: float = 100
@export var area: Area3D



func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if is_instance_valid(GameLogic.player) and area.overlaps_body(GameLogic.player):
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



func _ready() -> void:
	%Mesh.mesh.material.albedo_texture = %Viewport.get_texture()


