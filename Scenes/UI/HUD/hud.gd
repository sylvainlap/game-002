extends TextureRect

@onready var label = get_node("Label")

func _ready() -> void:
	EVENTS.nb_coins_changed.connect(_on_EVENTS_nb_coins_changed)
	EVENTS.character_hp_changed.connect(_on_EVENTS_character_hp_changed)


func _on_EVENTS_nb_coins_changed(value: int) -> void:
	label.set_text(str(value))


func _on_EVENTS_character_hp_changed(hp: int) -> void:
	var max_hp: float = 10.0
	var progress: float = float(hp) / max_hp * 100.0
	$Mask/HP_Bar.set_value(progress)
