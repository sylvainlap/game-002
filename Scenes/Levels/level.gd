extends Node2D

@onready var pathfinder = get_node("Walls&Ground/Pathfinder")


func _ready() -> void:
	EVENTS.actor_died.connect(_on_actor_died)
	
	var ennemies_array = get_tree().get_nodes_in_group("Enemy")
	
	for ennemy in ennemies_array:
		ennemy.pathfinder = pathfinder


func _on_actor_died(actor: Actor) -> void:
	if actor is Enemy:
		var ennemies_array = get_tree().get_nodes_in_group("Enemy")
		
		if ennemies_array == [actor]:
			EVENTS.room_finished.emit()
