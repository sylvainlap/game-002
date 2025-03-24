extends Node

var nb_coins: int = 0: set = set_nb_coins, get = get_nb_coins


func set_nb_coins(value: int) -> void:
	if value != nb_coins:
		nb_coins = value
		EVENTS.emit_signal("nb_coins_changed", nb_coins)


func get_nb_coins() -> int:
	return nb_coins


func _ready() -> void:
	EVENTS.object_collected.connect(self._on_EVENTS_object_collected)


func _on_EVENTS_object_collected(object: Node2D) -> void:
	if object is Coin:
		set_nb_coins(nb_coins + 1)
