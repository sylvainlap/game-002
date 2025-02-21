extends TextureRect

@onready var label = get_node("Label")

func _ready() -> void:
	EVENTS.nb_coins_changed.connect(self._on_EVENTS_nb_coins_changed)

func _on_EVENTS_nb_coins_changed(value: int) -> void:
	label.set_text(str(value))
