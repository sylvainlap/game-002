extends CharacterBody2D

@onready var animated_sprite: Node = get_node("AnimatedSprite2D")

const SPEED: float = 300.0
var moving_direction := Vector2.ZERO
var facing_direction := Vector2.DOWN
var direction_dict: Dictionary = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"up": Vector2.UP,
	"down": Vector2.DOWN,
}
var is_attacking: bool = false
var is_moving: bool = false


func _process(delta: float) -> void:
	velocity = moving_direction * SPEED
	move_and_slide()


func _input(event: InputEvent) -> void:
	moving_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	moving_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if moving_direction != Vector2.ZERO:
		facing_direction = moving_direction
	
	moving_direction = moving_direction.normalized()
	
	if Input.is_action_just_pressed("ui_accept"):
		is_attacking = true
	
	var direction_name = find_direction_name(facing_direction)
	
	if is_attacking:
		# attack animation
		var animation_name = "attack_" + direction_name
		if animated_sprite.get_sprite_frames().has_animation(animation_name):
				animated_sprite.play(animation_name)
	else:
		# idle animation
		if moving_direction == Vector2.ZERO:
			animated_sprite.stop()
			animated_sprite.set_frame(0)
		else:
			# moving animation
			is_moving = true
			var animation_name = "move_" + direction_name
			if animated_sprite.get_sprite_frames().has_animation(animation_name):
				animated_sprite.play(animation_name)


func find_direction_name(dir: Vector2) -> String:
	var values = direction_dict.values()
	var keys = direction_dict.keys()
	
	var index = values.find(dir)
	
	if index == -1:
		return ""
	else:
		return keys[index]

func _on_animated_sprite_2d_animation_finished() -> void:
	if "attack_".is_subsequence_of(animated_sprite.get_animation()):
		is_attacking = false
		
		var direction_name = find_direction_name(facing_direction)
		
		var animation_name = "move_" + direction_name
		if animated_sprite.get_sprite_frames().has_animation(animation_name):
			animated_sprite.set_animation(animation_name)
			animated_sprite.stop()
			animated_sprite.set_frame(0)
		
		
