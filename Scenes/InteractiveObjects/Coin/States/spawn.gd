extends State
class_name CoinSpawnState

const GRAVITY: float = 40.0

var spawn_v_force: float = -400.0
var spawn_dir: Vector2 = Vector2.ZERO
var spawn_dir_force: float = 200.0
var spawn_dir_velocity: Vector2 = Vector2.ZERO
var damping: float = 20.0


func enter_state() -> void:
	var rdm_angle = randf_range(0.0, 360.0)
	spawn_dir = Vector2(sin(rdm_angle), cos(rdm_angle))


func update(delta: float) -> void:
	spawn_v_force += GRAVITY
	var spawn_v_velocity = Vector2(0.0, spawn_v_force)
	spawn_dir_velocity = spawn_dir * spawn_dir_force
	spawn_dir_velocity = spawn_dir_velocity.limit_length(spawn_dir_velocity.length() - damping)
	var velocity = spawn_v_velocity + spawn_dir_velocity
	
	owner.position += velocity * delta
