extends State
class_name SkeletonMoveState

func update(delta: float) -> void:
	owner.move_along_path(delta)
