extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Input.is_action_just_pressed("click"):
		get_tree().change_scene_to_file("res://tutorial.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		get_tree().change_scene_to_file("res://controls.tscn")
