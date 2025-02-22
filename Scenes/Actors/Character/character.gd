extends Actor
class_name Character


func _input(_event: InputEvent) -> void:
	var direction := Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)
	
	set_moving_direction(direction.normalized())
	
	if Input.is_action_just_pressed("ui_accept"):
		set_state(STATE.ATTACK)

	if get_state() != STATE.ATTACK:
		if get_moving_direction() == Vector2.ZERO:
			set_state(STATE.IDLE)
		else:
			set_state(STATE.MOVE)


func _interaction_attempt() -> bool:
	var bodies_array = attack_hit_box.get_overlapping_bodies()
	
	var attempt_success := false
	
	for body in bodies_array:
		if body.has_method("interact"):
			body.interact()
			attempt_success = true
	
	return attempt_success


func _on_state_changed() -> void:
	if get_state() == STATE.ATTACK:
		if _interaction_attempt():
			set_state(STATE.IDLE)

	super()
