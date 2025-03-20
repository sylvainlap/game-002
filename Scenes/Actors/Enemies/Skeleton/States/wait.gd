extends State
class_name SkeleteonWaitState

@export var min_wait_time: float = 0.8
@export var max_wait_time: float = 1.2

signal wait_time_finished


func enter_state() -> void:
	if !is_instance_valid(owner):
		return
		
	if owner.state_machine != null:
		owner.state_machine.set_state("Idle")

	var wait_time = randf_range(min_wait_time, max_wait_time)
	$Timer.start(wait_time)


func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	wait_time_finished.emit()
