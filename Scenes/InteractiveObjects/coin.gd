extends Node2D

@onready var area = get_node("Area2D")
@onready var coin_sprite = get_node("CoinSprite")
@onready var shadow_sprite = get_node("ShadowSprite")
@onready var audio_stream = get_node("AudioStreamPlayer2D")
@onready var animation_player = get_node("AnimationPlayer")

enum STATE {
	IDLE,
	FOLLOW,
	COLLECTED
}

var state: int = STATE.IDLE
var target: Node2D = null
var speed: float = 400.0

func _ready() -> void:
	animation_player.play("wave")

func _physics_process(delta: float) -> void:
	if state == STATE.FOLLOW:
		var target_pos = target.get_position()
		var spd = speed * delta
		if position.distance_to(target_pos) < spd:
			position = target_pos
			_collect()
		else:
			position = position.move_toward(target_pos, spd)
			
func _collect() -> void:
	audio_stream.play()
	coin_sprite.set_visible(false)
	shadow_sprite.set_visible(false)
	state = STATE.COLLECTED
	
	EVENTS.emit_signal("coin_collected")
	
	await audio_stream.finished
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if state == STATE.IDLE:
		state = STATE.FOLLOW
		target = body
		animation_player.stop()

func _on_timer_timeout() -> void:
	if state == STATE.IDLE:
		coin_sprite.play("rotation")
		shadow_sprite.play("rotation")

func _on_coin_sprite_animation_finished() -> void:
	if coin_sprite.get_animation() == "rotation":
		coin_sprite.play("idle")
		shadow_sprite.play("idle")
