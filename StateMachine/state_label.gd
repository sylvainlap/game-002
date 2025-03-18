extends Label
class_name StateLabel

func _ready() -> void:
	get_parent().state_changed_recursive.connect(_on_state_changed_recursive)


func _update_text(state: Node2D) -> void:
	set_text(get_state_name_recursive(state))


func get_state_name_recursive(state: Node2D) -> String:
	if state == null:
		return ""

	if state is StateMachine:
		return state.name + " / " + get_state_name_recursive(state.get_state())
	
	return state.name


func _on_state_changed_recursive(state: Node2D) -> void:
	_update_text(state)
