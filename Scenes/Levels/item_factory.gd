extends Node2D
class_name ItemFactory

var item_scene = preload("res://Scenes/InteractiveObjects/Item/item.tscn")


func _ready() -> void:
	EVENTS.spawn_item.connect(_on_EVENTS_spawn_item)
	EVENTS.spawn_scene_item.connect(_on_EVENTS_spawn_scene_item)


func _spawn_item(item_data: ItemData, pos: Vector2) -> void:
	var item = item_scene.instantiate()
	owner.add_child(item)
	item.set_item_data(item_data)
	item.set_global_position(pos)


func _spawn_scene_item(scene: PackedScene, pos: Vector2) -> void:
	var item = scene.instantiate()
	owner.add_child(item)
	item.set_global_position(pos)


func _on_EVENTS_spawn_item(item_data: ItemData, pos: Vector2) -> void:
	_spawn_item(item_data, pos)


func _on_EVENTS_spawn_scene_item(scene: PackedScene, pos: Vector2) -> void:
	_spawn_scene_item(scene, pos)
