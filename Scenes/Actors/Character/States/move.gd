extends State
class_name CharacterMoveState

func update(delta: float) -> void:
	owner.velocity = owner.moving_direction * owner.SPEED
	owner.move_and_slide()
