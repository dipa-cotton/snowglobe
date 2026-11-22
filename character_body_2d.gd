extends CharacterBody2D

@export var next_level = 2
var health: int = 3:
	set(value):
		health = value
		if health <= 0:
			Global.last_level = get_tree().current_scene.scene_file_path
			get_tree().change_scene_to_file("res://dead.tscn")
			health = 3
var level = 0
var is_playing_heart = false
@onready var _animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -700

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("reset"):
		print("?")
		#Global.last_level = get_tree().current_scene.scene_file_path
		get_tree().reload_current_scene()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_pickup_area_area_entered(area):
	if area.is_in_group("object") and not $holding.visible:
		area.queue_free()
		$holding.visible = true
	
	if area.is_in_group("breakice"):
		print("ice")
		if !area.get_node("breakice2").is_playing():
			area.get_node("breakice2").play("breakice")
			await get_tree().create_timer(3.0).timeout
			$"../breakarea/breakice2".visible = false
			$"../breakice".hide()
			$"../breakice/CollisionShape2D".set_deferred("disabled", true)
			await get_tree().create_timer(3.0).timeout
			area.get_node("breakice2").stop()
			$"../breakarea/breakice2".visible = true
			$"../breakice".show()
			$"../breakice/CollisionShape2D".set_deferred("disabled", false)
		
func _process(_delta):	
	if $holding.visible and not is_playing_heart:
		is_playing_heart = true
		await get_tree().create_timer(1.0).timeout
		$holding.visible = false
		is_playing_heart = false
		health += 1
		updateBar()
		print(health)
		
	$holding.visible = is_playing_heart
	_animated_sprite.visible = !is_playing_heart
	if Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("ui_down"):
			if is_playing_heart:
				$holding.play("heartcrouch")
			else:
				_animated_sprite.play("crouch")
		else:
			if is_playing_heart:
				$holding.play("heart")
			else:
				_animated_sprite.play("run")
	elif Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_down"):
			if is_playing_heart:
				$holding.play("heartcrouchb")
			else:
				_animated_sprite.play("bcrouch")
		else:
			if is_playing_heart:
				$holding.play("heartb")
			else:
				_animated_sprite.play("run_backwards")
	else:
		$holding.stop()
		_animated_sprite.stop()

func _on_flag_area_entered(area: Area2D) -> void:
	#area.next_level 
	get_tree().change_scene_to_file("res://level_" + str(next_level) + ".tscn")
	#level += 1
	#print(level)
	#print("level!")
	#get_tree().change_scene_to_file("res://level_2.tscn")

	
func _on_spike_area_entered(area: Area2D) -> void:
	health -= 2
	prints(health, "spike area1")
	updateBar()
func updateBar():
	$"../CanvasLayer/health_label".text = "[color=red]Health: [b]%d[/b][/color]" % health
	if health == 1:
		$"../CanvasLayer/cold".visible = true
		$"../CanvasLayer/hot".visible = false
		$"../CanvasLayer/mid".visible = false
	if health == 2:
		$"../CanvasLayer/mid".visible = true
		$"../CanvasLayer/cold".visible = false
		$"../CanvasLayer/hot".visible = false
	if health >= 3:
		$"../CanvasLayer/hot".visible = true
		$"../CanvasLayer/cold".visible = false
		$"../CanvasLayer/mid".visible = false
func _on_spike_2_area_entered(area: Area2D) -> void:
	health -= 2
	print(area.name)
	prints(health, "spike area2")
	updateBar()
#func _on_light_area_entered(area: Area2D) -> void:
		#light_timer.start()
#
#func _on_light_area_exited(area: Area2D) -> void:
	## Stop the timer if the character leaves the light early
	#if area.is_in_group("light"):
		#light_timer.stop()
