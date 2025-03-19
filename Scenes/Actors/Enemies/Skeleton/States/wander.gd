extends StateMachine
class_name SkeletonWanderState

@onready var wait = get_node("Wait")

@export var min_wander_distance = 40.0
@export var max_wander_distance = 70.0


func _generate_random_dest() -> Vector2:
	var rdm_angle = deg_to_rad(randf_range(0.0, 360.0))
	var direction = Vector2(cos(rdm_angle), sin(rdm_angle))
	var distance = randf_range(min_wander_distance, max_wander_distance)
	
	return owner.global_position + direction * distance


func _find_wander_destination() -> Vector2:
	var pos = _generate_random_dest()
	
	if owner.pathfinder != null:
		while(!owner.pathfinder.is_position_valid(pos)):
			pos = _generate_random_dest()
	
	return pos


func _ready() -> void:
	wait.wait_time_finished.connect(_on_wait_time_finished)
	owner.move_path_finished.connect(_on_move_path_finished)
	
	super._ready()


func _on_wait_time_finished() -> void:
	var destination = _find_wander_destination()
	owner.update_move_path(destination)
	set_state("GoTo")


func _on_move_path_finished() -> void:
	if is_current_state():
		set_state("Wait")
