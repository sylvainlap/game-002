extends Actor
class_name Enemy

@onready var behaviour_tree = get_node("BehaviourTree")
@onready var chase_area = get_node("ChaseArea")
@onready var attack_area = get_node("AttackArea")

signal target_in_chase_area_changed
signal target_in_attack_area_changed
signal move_path_finished

var target: Node2D = null
var target_in_chase_area: bool = false : set = set_target_in_chase_area
var target_in_attack_area: bool = false : set = set_target_in_attack_area
var path: Array = []

var pathfinder: Pathfinder = null


func set_target_in_chase_area(value: bool) -> void:
	if value != target_in_chase_area:
		target_in_chase_area = value
		target_in_chase_area_changed.emit(target_in_chase_area)


func set_target_in_attack_area(value: bool) -> void:
	if value != target_in_attack_area:
		target_in_attack_area = value
		target_in_attack_area_changed.emit(target_in_attack_area)


func _update_target() -> void:
	if !target_in_attack_area && !target_in_chase_area:
		target = null


func update_move_path(dest: Vector2) -> void:
	if pathfinder == null:
		path = [dest]
	else:
		path = pathfinder.find_path(global_position, dest)


func move_along_path(delta: float) -> void:
	if path.is_empty():
		return
		
	var dir = global_position.direction_to(path[0])
	var dist = global_position.distance_to(path[0])
	
	set_moving_direction(dir)
	
	if dist <= SPEED * delta:
		move_and_collide(dir * dist)
		path.remove_at(0)
		
		if path.is_empty():
			move_path_finished.emit()
	else:
		move_and_collide(dir * SPEED * delta)


func can_attack() -> bool:
	return !get_node("BehaviourTree/Attack").is_cooldown_running() && target_in_attack_area


func _update_behaviour_state() -> void:
	if can_attack():
		behaviour_tree.set_state("Attack")
	elif target_in_chase_area:
		behaviour_tree.set_state("Chase")
	else:
		behaviour_tree.set_state("Wander")


func _ready() -> void:
	chase_area.body_entered.connect(_on_chase_area_body_entered)
	chase_area.body_exited.connect(_on_chase_area_body_exited)
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)
	target_in_chase_area_changed.connect(_on_target_in_chase_area_changed)
	target_in_attack_area_changed.connect(_on_target_in_attack_area_changed)
	
	super._ready()


func _on_chase_area_body_entered(body: Node2D) -> void:
	if body is Character:
		set_target_in_chase_area(true)
		target = body


func _on_chase_area_body_exited(body: Node2D) -> void:
	if body is Character:
		set_target_in_chase_area(false)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Character:
		set_target_in_attack_area(true)
		target = body


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Character:
		set_target_in_attack_area(false)


func _on_target_in_chase_area_changed(value: bool) -> void:
	_update_target()
	_update_behaviour_state()


func _on_target_in_attack_area_changed(value: bool) -> void:
	_update_target()
	
	if target_in_attack_area:
		_update_behaviour_state()


func _on_moving_direction_changed() -> void:
	if abs(get_moving_direction().x) > abs(get_moving_direction().y):
		set_facing_direction(Vector2(sign(moving_direction.x), 0))
	else:
		set_facing_direction(Vector2(0, sign(moving_direction.y)))


func _on_state_changed(state) -> void:
	if state.name == "Idle" && state_machine.get_previous_state_name() == "Attack":
		_update_behaviour_state()

	super._on_state_changed(state)
