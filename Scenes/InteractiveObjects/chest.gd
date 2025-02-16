extends StaticBody2D

@onready var animated_sprite = get_node("AnimatedSprite2D")

enum STATE {
	IDLE,
	OPENING,
	OPENED
}

var state: int = STATE.IDLE

func interact() -> void:
	if state != STATE.IDLE:
		return
		
	state = STATE.OPENING
	animated_sprite.play("open")

func _on_animated_sprite_2d_animation_finished() -> void:
	print(animated_sprite.get_animation())
	if animated_sprite.get_animation() == "open":
		state = STATE.OPENED
