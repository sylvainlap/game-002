extends ColorRect


func _fade(fade_in: bool) -> void:
	var color_tween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	if fade_in:
		color_tween.tween_property(self, "color:a", 0.5, 0.5)
	if !fade_in:
		color_tween.tween_property(self, "color:a", 0.0, 0.5)


func _on_inventory_showed_changed(showed: bool) -> void:
	_fade(showed)
