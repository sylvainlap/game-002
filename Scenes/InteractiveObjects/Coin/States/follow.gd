extends State
class_name CoinFollowState

@export var speed: float = 400.0
var target: Node2D = null


func update(delta: float) -> void:
	if target == null:
		return
	
	var target_pos = target.get_position()
	var dist = owner.object.position.distance_to(target_pos)
	var spd = speed * delta
	
	if dist < spd:
		owner.object.position = target_pos
		owner.collect()
	else:
		owner.object.position = owner.object.position.move_toward(target_pos, spd)
