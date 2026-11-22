extends Area2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		Cutscreen.play_intro_cutscene()
