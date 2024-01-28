extends Node2D
class_name Screen


# 1. MAKE ME LAUGH
# 2. Put together a funny sentence and atempt to reach a rating of x or higher 
#	on a scale of 1 to 10.
# 3. Processing input ...
# 4. Comment'
# 5. x/10
# 6. a) Congratulations, you passed!
#	 b) You failed. Prepare to die!


func _ready() -> void:
	hide_all()
	%CRT.show()
	GameLogic.screen = self
	#await get_tree().create_timer(2).timeout
	#display_required_rating(5)
	#display_default()
	#await get_tree().create_timer(1).timeout
	#display_rating(3)
	#await display_happy()
	#await get_tree().create_timer(1).timeout
	#await display_processing()
	#await get_tree().create_timer(1).timeout
	#await display_angry()
	#await get_tree().create_timer(1).timeout

func hide_all(clear_text := false) -> void:
	%Default.hide()
	%Angry.hide()
	%Happy.hide()
	%Processing.visible_ratio = 0
	%DieText.visible_ratio = 0
	%LaughText.visible_ratio = 0
	%Comment.visible_characters = 0
	%Rating.text = ""
	%Required.visible_ratio = 0
	%Laugh.visible_characters = 0


func display_angry() -> void:
	hide_all()
	%Angry.show()
	
	var tween := create_tween()
	tween.tween_property(%DieText, "visible_ratio", 1, .5)
	tween.tween_interval(1)
	await tween.finished

func display_happy() -> void:
	hide_all()
	%Happy.show()
	
	var tween := create_tween()
	tween.tween_property(%LaughText, "visible_ratio", 1, 3)
	tween.tween_interval(1)
	await tween.finished

func display_default(height: float = 0) -> void:
	hide_all()
	%Default.position.y = -height
	%Default.show()

func display_processing() -> void:
	hide_all(true)
	
	var tween := create_tween()
	tween.tween_property(%Processing, "visible_ratio", 1, 1)
	tween.tween_interval(1)
	await tween.finished

func display_rating(rating: int = 10) -> void:
	hide_all()
	%Rating.text = "%s/10" % rating
	await get_tree().create_timer(3).timeout

func display_comment(comment: String) -> void:
	%Comment.text = comment
	display_default(%Comment.get_content_height() / %Faces.scale.x)
	
	var tween := create_tween()
	tween.tween_property(%Comment, "visible_characters", len(comment), len(comment) * .1)
	tween.tween_interval(3)
	await tween.finished

func display_main_menu() -> void:
	hide_all()
	%MainMenu.display()

func display_required_rating(rating: int) -> void:
	hide_all()
	%Required.text = "Submit your sentence.\nIf I rate it less than %s you [wave amp=80]die[/wave]." % rating
	
	var tween := create_tween()
	tween.tween_property(%Required, "visible_ratio", 1, 3)
	tween.tween_interval(1)
	await tween.finished

func display_make_me_laugh() -> void:
	hide_all()
	await get_tree().create_timer(.5).timeout
	%Laugh.visible_characters = 4
	await get_tree().create_timer(.5).timeout
	%Laugh.visible_characters = 7
	await get_tree().create_timer(.5).timeout
	%Laugh.visible_characters = -1
	await get_tree().create_timer(2).timeout
	
	


