extends StaticBody2D

@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var collision_shape = get_node("CollisionShape2D")

enum STATE {
	IDLE,
	BREAKING,
	BROKEN
}

var state: int = STATE.IDLE

func destroy() -> void:
	if state != STATE.IDLE:
		return
		
	state = STATE.BREAKING
	animated_sprite.play("break")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "break":
		state = STATE.BROKEN
		collision_shape.set_disabled(true)
