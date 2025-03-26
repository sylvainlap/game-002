extends Control
class_name Inventory

signal showed_changed

var showed: bool = false : set = set_showed


func _ready() -> void:
	showed_changed.connect(_on_showed_changed)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		set_showed(!showed)


func set_showed(value: bool) -> void:
	if showed != value:
		showed = value
		showed_changed.emit()


func _animation() -> void:
	var visibility_tween = get_tree().create_tween()
	if showed:
		visibility_tween.tween_property(self, "position:x", -180, 0.5).set_trans(Tween.TRANS_CUBIC)
	if !showed:
		visibility_tween.tween_property(self, "position:x", 0, 0.5).set_trans(Tween.TRANS_CUBIC)


func _on_showed_changed() -> void:
	_animation()
