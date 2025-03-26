extends Behaviour
class_name CollectableBehaviour

@onready var state_machine = get_node("StateMachine")
@onready var follow_state = get_node("StateMachine/Follow")
@onready var follow_area = get_node("FollowArea")
@onready var animation_player = get_node("AnimationPlayer")


func collect() -> void:
	EVENTS.object_collected.emit(object)
	state_machine.set_state("Collect")
	if animation_player.has_animation("Collect"):
		animation_player.play("Collect")
	else:
		object.queue_free()


func _follow_target(body: Node2D) -> void:
	state_machine.set_state("Follow")
	follow_state.target = body


func _on_follow_area_body_entered(body: Node2D) -> void:
	if state_machine.get_state_name() == "Idle":
		_follow_target(body)


func _on_state_machine_state_changed(new_state: Node2D) -> void:
	if new_state.name == "Idle":
		for body in follow_area.get_overlapping_bodies():
			if body is Character:
				_follow_target(body)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Collect":
		object.queue_free()
