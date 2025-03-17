extends Label
class_name StateLabel

func _ready() -> void:
	get_parent().state_changed.connect(_on_state_changed)


func _update_text(state: Node2D) -> void:
	set_text(state.name)


func _on_state_changed(new_state: Node2D) -> void:
	_update_text(new_state)
