extends Node2D
class_name Item

@export var item_data: ItemData = null: set = set_item_data


func set_item_data(value: ItemData) -> void:
	item_data = value
	if item_data != null:
		$Sprite.set_texture(item_data.world_texture)
