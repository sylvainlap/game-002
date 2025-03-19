extends Node2D

@onready var pathfinder = get_node("Walls&Ground/Pathfinder")

func _ready() -> void:
	var ennemies_array = get_tree().get_nodes_in_group("Enemy")
	
	for ennemy in ennemies_array:
		ennemy.pathfinder = pathfinder
