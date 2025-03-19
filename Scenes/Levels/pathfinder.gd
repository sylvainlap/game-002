extends Node
class_name Pathfinder

@onready var tilemap: TileMap = get_parent()

var astar = AStar2D.new()
var room_size: Vector2 = Vector2.ZERO


func _ready() -> void:
	EVENTS.obstacle_destroyed.connect(_on_EVENTS_obstacle_destroyed)

	room_size = tilemap.get_used_rect().size
	
	init_astar()
	_disable_all_obstacles_points()


func find_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	var from_cell = tilemap.local_to_map(from)
	var to_cell = tilemap.local_to_map(to)
	
	var from_cell_id = _compute_point_index(from_cell)
	var to_cell_id = _compute_point_index(to_cell)
	
	var point_path = astar.get_point_path(from_cell_id, to_cell_id)
	var path: PackedVector2Array = PackedVector2Array()
	
	for i in range(point_path.size()):
		if i == 0:
			continue
		
		var point = point_path[i]
		
		var pos = tilemap.map_to_local(point) if i != point_path.size() - 1 else to
		path.append(pos)
	
	return path


func _compute_point_index(cell: Vector2) -> int:
	return int(abs(cell.x + room_size.x * cell.y))


func _disable_all_obstacles_points() -> void:
	for obstacle in get_tree().get_nodes_in_group("Obstacle"):
		_update_obstacle_point(obstacle, true)


func _update_obstacle_point(obstacle: Node2D, disabled: bool) -> void:
	var global_position = obstacle.get_global_position()
	var cell = tilemap.local_to_map(global_position)
	var cell_id = _compute_point_index(cell)
	astar.set_point_disabled(cell_id, disabled)


func _astar_connect_points(point_array: Array, connect_diagonals : bool = true) -> void:
	for point in point_array:
		var point_index = _compute_point_index(point)
		
		if !astar.has_point(point_index):
			continue
		
		for x_offset in range(3):
			for y_offset in range(3):
				if !connect_diagonals && x_offset in [0, 2] && y_offset in [0, 2]:
					continue
				
				var point_relative = Vector2i(point.x + x_offset - 1, point.y + y_offset - 1)
				var point_rel_id = _compute_point_index(point_relative)
				
				if point_relative == point or !astar.has_point(point_rel_id):
					continue
				
				astar.connect_points(point_index, point_rel_id)


func is_position_valid(pos: Vector2) -> bool:
	var cell = tilemap.local_to_map(pos)
	var point_id = _compute_point_index(cell)
	
	return astar.has_point(point_id) && !astar.is_point_disabled(point_id)


func init_astar() -> void:
	var layer_id = 0
	var cells_array: Array[Vector2i] = tilemap.get_used_cells(layer_id)
	for cell in cells_array:
		var atlas_coords = tilemap.get_cell_atlas_coords(layer_id, cell)
		var is_ground = atlas_coords.y == 7
		
		if is_ground:
			var id = _compute_point_index(cell)
			astar.add_point(id, cell)
	
	_astar_connect_points(cells_array)


func _on_EVENTS_obstacle_destroyed(obstacle: Node2D) -> void:
	_update_obstacle_point(obstacle, false)
