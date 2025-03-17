extends State
class_name SkeletonChaseState

func enter_state() -> void:
	owner.state_machine.set_state("Move")


func update(delta: float) -> void:
	owner.update_move_path(owner.target.global_position)
