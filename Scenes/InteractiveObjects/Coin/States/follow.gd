extends State
class_name CoinFollowState

const SPEED: float = 400.0

var target: Node2D = null


func update(delta: float) -> void:
	if target == null:
		return
	
	var target_pos = target.get_position()
	var dist = owner.position.distance_to(target_pos)
	var spd = SPEED * delta
	
	
	if dist < spd:
		owner.position = target_pos
		owner.collect()
	else:
		owner.position = owner.position.move_toward(target_pos, spd)
