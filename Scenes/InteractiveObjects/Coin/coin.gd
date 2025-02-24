extends Node2D

@onready var area = get_node("Area2D")
@onready var coin_sprite = get_node("CoinSprite")
@onready var shadow_sprite = get_node("ShadowSprite")
@onready var audio_stream = get_node("AudioStreamPlayer2D")
@onready var animation_player = get_node("AnimationPlayer")
@onready var state_machine = get_node("StateMachine")

const GRAVITY: float = 40.0

var target: Node2D = null
var speed: float = 400.0
var spawn_dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	animation_player.play("wave")
	state_machine.state_changed.connect(_on_state_changed)
	_init_spawn_values()


func _init_spawn_values() -> void:
	var rdm_angle = randf_range(0.0, 360.0)
	spawn_dir = Vector2(sin(rdm_angle), cos(rdm_angle))


func _collect() -> void:
	audio_stream.play()
	coin_sprite.set_visible(false)
	shadow_sprite.set_visible(false)
	state_machine.set_state("Collected")
	
	EVENTS.coin_collected.emit()
	
	await audio_stream.finished
	queue_free()


func _follow_target(body: Node2D) -> void:
	state_machine.set_state("Follow")
	target = body


func _on_area_2d_body_entered(body: Node2D) -> void:
	if state_machine.get_state_name() == "Idle":
		_follow_target(body)


func _on_timer_timeout() -> void:
	if state_machine.get_state_name() == "Idle":
		coin_sprite.play("rotation")
		shadow_sprite.play("rotation")


func _on_coin_sprite_animation_finished() -> void:
	if coin_sprite.get_animation() == "rotation":
		coin_sprite.play("idle")
		shadow_sprite.play("idle")


func _on_spawn_duration_timer_timeout() -> void:
	state_machine.set_state("Idle")


func _on_state_changed(new_state: Node2D):
	if new_state.name == "Idle":
		for body in area.get_overlapping_bodies():
			if body is Character:
				_follow_target(body)
