extends State
class_name CoinSpawnState

var spawn_v_force: float = -400.0
var spawn_dir_force: float = 200.0
var spawn_dir_velocity: Vector2 = Vector2.ZERO
var damping: float = 20.0


func _spawn(delta: float) -> void:
	spawn_v_force += owner.GRAVITY
	var spawn_v_velocity = Vector2(0.0, spawn_v_force)
	spawn_dir_velocity = owner.spawn_dir * spawn_dir_force
	spawn_dir_velocity = spawn_dir_velocity.limit_length(spawn_dir_velocity.length() - damping)
	var velocity = spawn_v_velocity + spawn_dir_velocity
	
	position += velocity * delta


func update(delta: float) -> void:
	_spawn(delta)
