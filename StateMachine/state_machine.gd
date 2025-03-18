extends State
class_name StateMachine

var current_state: Node2D = null: get = get_state, set = set_state
var previous_state: Node2D = null: get = get_previous_state

signal state_changed(new_state: Node2D)
signal state_changed_recursive(new_state: Node2D)


func set_state(new_state) -> void:
	if new_state is String:
		new_state = get_node_or_null(new_state)

	if new_state == current_state:
		return
		
	if current_state != null:
		current_state.exit_state()

	previous_state = current_state
	current_state = new_state
	
	if current_state != null:
		current_state.enter_state()

	state_changed.emit(new_state)


func get_state() -> Node2D:
	return current_state


func get_state_name() -> String:
	if current_state == null:
		return ""

	return current_state.name


func get_previous_state() -> Node2D:
	return previous_state


func get_previous_state_name() -> String:
	return previous_state.name


func _ready() -> void:
	state_changed.connect(_on_state_changed)
	
	if state_machine is StateMachine:
		state_changed_recursive.connect(state_machine._on_state_changed_recursive)

	set_to_default_state()


func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)


func enter_state() -> void:
	set_to_default_state()


func exit_state() -> void:
	set_state(null)


func set_to_default_state() -> void:
	set_state(get_child(0))


func _on_state_changed(_state: Node2D) -> void:
	state_changed_recursive.emit(current_state)


func _on_state_changed_recursive(_state: Node2D) -> void:
	state_changed_recursive.emit(current_state)
