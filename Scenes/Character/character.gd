extends CharacterBody2D

@onready var animated_sprite: Node = get_node("AnimatedSprite2D")


const SPEED = 300.0
var direction = Vector2.ZERO


func _process(delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()


func _input(event: InputEvent) -> void:
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	direction = direction.normalized()
	
	if direction == Vector2.ZERO:
		animated_sprite.stop()
	if direction == Vector2.RIGHT:
		animated_sprite.play("move_right")
	if direction == Vector2.LEFT:
		animated_sprite.play("move_left")
	if direction == Vector2.DOWN:
		animated_sprite.play("move_down")
	if direction == Vector2.UP:
		animated_sprite.play("move_up")
