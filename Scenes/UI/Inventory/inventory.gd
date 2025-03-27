extends Control
class_name Inventory

signal showed_changed

var showed: bool = false : set = set_showed


func _ready() -> void:
	showed_changed.connect(_on_showed_changed)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		set_showed(!showed)
	
	if Input.is_action_just_pressed("ui_up") && showed:
		$Panel/VBoxContainer/InventoryItemList.navigate_up()
	
	if Input.is_action_just_pressed("ui_down") && showed:
		$Panel/VBoxContainer/InventoryItemList.navigate_down()


func set_showed(value: bool) -> void:
	if showed != value:
		showed = value
		showed_changed.emit(showed)


func _animation() -> void:
	var visibility_tween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	if showed:
		visibility_tween.tween_property(self, "position:x", -180, 0.5).set_trans(Tween.TRANS_CUBIC)
	if !showed:
		visibility_tween.tween_property(self, "position:x", 0, 0.5).set_trans(Tween.TRANS_CUBIC)


func _on_showed_changed(_showed: bool) -> void:
	_animation()
	get_tree().set_pause(showed)
