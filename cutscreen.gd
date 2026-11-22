extends Node

func play_intro_cutscene() -> void:
	get_tree().change_scene_to_file("res://beg_1.tscn")
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://beg_2.tscn")
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://beg_3.tscn")
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://beg_4.tscn")
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://controls.tscn")
