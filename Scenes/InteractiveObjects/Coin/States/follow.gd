extends State
class_name CoinFollowState


func _follow(delta: float) -> void:
	if owner.target == null:
		return
	
	var target_pos = owner.target.get_position()
	var spd = owner.speed * delta
	if position.distance_to(target_pos) < spd:
		position = target_pos
		owner._collect()
	else:
		position = position.move_toward(target_pos, spd)


func update(delta: float) -> void:
	_follow(delta)
