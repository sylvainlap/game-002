extends Node2D

@onready var area = get_node("Area2D")
@onready var coin_sprite = get_node("CoinSprite")
@onready var shadow_sprite = get_node("ShadowSprite")
@onready var audio_stream = get_node("AudioStreamPlayer2D")
@onready var animation_player = get_node("AnimationPlayer")

enum STATE {
	SPAWN,
	IDLE,
	FOLLOW,
	COLLECTED
}

const GRAVITY: float = 40.0

var state: int = STATE.SPAWN: set = set_state, get = get_state
var target: Node2D = null
var speed: float = 400.0
var spawn_dir: Vector2 = Vector2.ZERO
var spawn_v_force: float = -400.0
var spawn_dir_force: float = 200.0
var spawn_dir_velocity: Vector2 = Vector2.ZERO
var damping: float = 20.0

signal state_changed


func set_state(new_state: int) -> void:
	if new_state != state:
		state = new_state
		state_changed.emit()


func get_state() -> int:
	return state


func _ready() -> void:
	animation_player.play("wave")
	_init_spawn_values()


func _physics_process(delta: float) -> void:
	match(get_state()):
		STATE.FOLLOW:
			_follow(delta)
		STATE.SPAWN:
			_spawn(delta)


func _follow(delta: float) -> void:
	if target == null:
		return
	
	var target_pos = target.get_position()
	var spd = speed * delta
	if position.distance_to(target_pos) < spd:
		position = target_pos
		_collect()
	else:
		position = position.move_toward(target_pos, spd)


func _spawn(delta: float) -> void:
	spawn_v_force += GRAVITY
	var spawn_v_velocity = Vector2(0.0, spawn_v_force)
	spawn_dir_velocity = spawn_dir * spawn_dir_force
	spawn_dir_velocity = spawn_dir_velocity.limit_length(spawn_dir_velocity.length() - damping)
	var velocity = spawn_v_velocity + spawn_dir_velocity
	
	position += velocity * delta


func _init_spawn_values() -> void:
	var rdm_angle = randf_range(0.0, 360.0)
	spawn_dir = Vector2(sin(rdm_angle), cos(rdm_angle))


func _collect() -> void:
	audio_stream.play()
	coin_sprite.set_visible(false)
	shadow_sprite.set_visible(false)
	set_state(STATE.COLLECTED)
	
	EVENTS.emit_signal("coin_collected")
	
	await audio_stream.finished
	queue_free()


func _follow_target(body: Node2D) -> void:
	set_state(STATE.FOLLOW)
	target = body


func _on_area_2d_body_entered(body: Node2D) -> void:
	if get_state() == STATE.IDLE:
		_follow_target(body)


func _on_timer_timeout() -> void:
	if get_state() == STATE.IDLE:
		coin_sprite.play("rotation")
		shadow_sprite.play("rotation")


func _on_coin_sprite_animation_finished() -> void:
	if coin_sprite.get_animation() == "rotation":
		coin_sprite.play("idle")
		shadow_sprite.play("idle")


func _on_spawn_duration_timer_timeout() -> void:
	set_state(STATE.IDLE)


func _on_state_changed() -> void:
	if get_state() == STATE.IDLE:
		for body in area.get_overlapping_bodies():
			if body is Character:
				_follow_target(body)
