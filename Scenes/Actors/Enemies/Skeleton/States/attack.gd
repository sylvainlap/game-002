extends State
class_name SkeletonAttackState

@onready var cooldown = get_node("Cooldown")

func enter_state() -> void:
	owner.state_machine.set_state("Attack")
	cooldown.start()


func is_cooldown_running() -> bool:
	return !cooldown.is_stopped() && !cooldown.is_paused()
