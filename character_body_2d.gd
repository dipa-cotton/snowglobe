extends CharacterBody2D

var health: int = 3:
	set(value):
		health = value
		if health <= 0:
			get_tree().call_deferred("reload_current_scene")

var level = 1
var is_playing_heart = false
@onready var _animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -600

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
	
func _input(event):
	if $holding.visible and not is_playing_heart and Input.is_action_pressed("ui_right"):
		is_playing_heart = true
		$AnimatedSprite2D.visible = false
		$holding.play("heart")
		await get_tree().create_timer(1.0).timeout
		$holding.visible = false
		$AnimatedSprite2D.visible = true
		is_playing_heart = false
		health += 1
		updateBar()
		print(health)
		
	elif $holding.visible and not is_playing_heart and Input.is_action_pressed("ui_left"):
		is_playing_heart = true
		$AnimatedSprite2D.visible = false
		$holding.play("heartb")
		await get_tree().create_timer(1.0).timeout
		$holding.visible = false
		$AnimatedSprite2D.visible = true
		is_playing_heart = false
		
func _process(_delta):
	if is_playing_heart:
		return
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play("run")
	elif Input.is_action_pressed("ui_left"):
		_animated_sprite.play("run_backwards")
	elif Input.is_action_pressed("jump"):
		_animated_sprite.play("jump")
	else:
		_animated_sprite.stop()
		
func _on_flag_area_entered(area: Area2D) -> void:
	level =+ 1
	
func _on_spike_area_entered(area: Area2D) -> void:
	health -= 2
	print(health)
	updateBar()
func updateBar():
	$"../CanvasLayer/health_label".text = "[color=red]Health: [b]%d[/b][/color]" % health
	if health == 1:
		$"../CanvasLayer/hot".visible = false
		$"../CanvasLayer/mid".visible = false
	if health == 2:
		$"../CanvasLayer/mid".visible = true
	if health >= 3:
		$"../CanvasLayer/cold".visible = false
		$"../CanvasLayer/mid".visible = false
