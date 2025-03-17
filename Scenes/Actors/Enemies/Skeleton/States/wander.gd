extends State
class_name SkeletonWanderState

func enter_state() -> void:
	if owner.state_machine == null:
		return

	owner.state_machine.set_state("Idle")
