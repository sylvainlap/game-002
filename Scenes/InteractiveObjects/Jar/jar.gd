extends StaticBody2D

@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var collision_shape = get_node("CollisionShape2D")
@onready var state_machine = get_node("StateMachine")

func destroy() -> void:
	if state_machine.get_state_name() == "Idle":
		state_machine.set_state("Breaking")
		animated_sprite.play("break")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "break":
		state_machine.set_state("Broken")
		collision_shape.set_disabled(true)
		EVENTS.obstacle_destroyed.emit(self)
