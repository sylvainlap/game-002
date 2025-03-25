extends StaticBody2D
class_name Chest

@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var collision_shape = get_node("CollisionShape2D")
@onready var state_machine = get_node("StateMachine")


func interact() -> void:
	if state_machine.get_state_name() == "Idle":
		state_machine.set_state("Opening")
		animated_sprite.play("open")
		


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "open":
		state_machine.set_state("Opened")
		$DropperBehaviour.drop_item()
