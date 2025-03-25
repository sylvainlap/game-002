extends Node2D
class_name Coin

@onready var coin_sprite = get_node("CoinSprite")
@onready var shadow_sprite = get_node("ShadowSprite")
@onready var animation_player = get_node("AnimationPlayer")
@onready var collectable_behaviour = get_node("CollectableBehaviour")


func _ready() -> void:
	animation_player.play("wave")


func _on_timer_timeout() -> void:
	if collectable_behaviour.state_machine.get_state_name() == "Idle":
		coin_sprite.play("rotation")
		shadow_sprite.play("rotation")


func _on_coin_sprite_animation_finished() -> void:
	if coin_sprite.get_animation() == "rotation":
		coin_sprite.play("idle")
		shadow_sprite.play("idle")
