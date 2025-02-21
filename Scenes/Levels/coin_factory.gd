extends Node2D

var coin_scene = preload("res://Scenes/InteractiveObjects/coin.tscn")

func _ready() -> void:
	EVENTS.spawn_coin.connect(self._on_EVENTS_spawn_coin)

func _spawn_coin(pos: Vector2) -> void:
	var coin = coin_scene.instantiate()
	coin.set_position(pos)
	owner.add_child(coin)

func _on_EVENTS_spawn_coin(pos: Vector2) -> void:
	_spawn_coin(pos)
