extends CharacterBody2D
class_name Actor

@onready var animated_sprite := get_node("AnimatedSprite2D")
@onready var attack_hit_box := get_node("AttackHitBox")
@onready var state_machine := get_node("StateMachine")

signal moving_direction_changed
signal facing_direction_changed
signal hp_changed

@export var speed := 300.0
@export var max_hp: int = 3

var moving_direction := Vector2.ZERO: set = set_moving_direction, get = get_moving_direction
var facing_direction := Vector2.DOWN: set = set_facing_direction, get = get_facing_direction

@onready var hp: int = max_hp: set = set_hp, get = get_hp

var direction_dict := {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"up": Vector2.UP,
	"down": Vector2.DOWN,
}


func set_moving_direction(new_moving_direction: Vector2) -> void:
	if new_moving_direction != moving_direction:
		moving_direction = new_moving_direction
		moving_direction_changed.emit()


func set_hp(new_value: int) -> void:
	new_value = clampi(new_value, 0, max_hp)
	
	if new_value != hp:
		hp = new_value
		hp_changed.emit()


func get_hp() -> int:
	return hp


func get_moving_direction() -> Vector2:
	return moving_direction


func set_facing_direction(new_facing_direction: Vector2) -> void:
	if new_facing_direction != facing_direction:
		facing_direction = new_facing_direction
		facing_direction_changed.emit()


func get_facing_direction() -> Vector2:
	return facing_direction


func _ready() -> void:
	state_machine.state_changed.connect(_on_state_changed)
	moving_direction_changed.connect(_on_moving_direction_changed)
	facing_direction_changed.connect(_on_facing_direction_changed)
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	animated_sprite.frame_changed.connect(_on_animated_sprite_2d_frame_changed)
	hp_changed.connect(_on_hp_changed)


func find_direction_name(dir: Vector2) -> String:
	var values := direction_dict.values()
	var keys := direction_dict.keys()
	
	var index := values.find(dir)
	
	if index == -1:
		return ""
	else:
		return keys[index]


func _update_animation() -> void:
	var direction_name := find_direction_name(get_facing_direction())
	var state_name = state_machine.get_state_name()

	animated_sprite.play(state_name.to_lower() + "_" + direction_name)


func _update_attack_hit_box_direction() -> void:
	var angle = get_facing_direction().angle()
	
	attack_hit_box.set_rotation_degrees(rad_to_deg(angle) - 90)


func _attack_effect() -> void:
	var bodies_array = attack_hit_box.get_overlapping_bodies()

	for body in bodies_array:
		if body.has_method("hurt"):
			body.face_position(global_position)
			var damage = _compute_damage(body)
			body.hurt(damage)
		elif body.has_method("destroy"):
			body.destroy()


func _compute_damage(target: Actor) -> int:
	return 1


func hurt(damage: int) -> void:
	if state_machine.get_state_name() == "Block":
		parry()
	else:
		set_hp(hp - damage)
		state_machine.set_state("Hurt")
		_hurt_feedback()


func parry() -> void:
	state_machine.set_state("Parry")


func _hurt_feedback() -> void:
	var hurt_tween = get_tree().create_tween()
	hurt_tween.tween_property(animated_sprite.material, "shader_parameter/opacity", 1.0, 0.1);
	hurt_tween.tween_property(animated_sprite.material, "shader_parameter/opacity", 0.0, 0.1);


func die() -> void:
	EVENTS.actor_died.emit(self)
	state_machine.set_state("Dead")
	$CollisionShape2D.set_disabled(true)


func face_position(pos: Vector2) -> void:
	var dir = global_position.direction_to(pos)
	face_direction(dir)


func face_direction(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		set_facing_direction(Vector2(sign(dir.x), 0))
	else:
		set_facing_direction(Vector2(0, sign(dir.y)))


func _on_state_changed(new_state: State) -> void:
	_update_animation()


func _on_facing_direction_changed() -> void:
	_update_animation()
	_update_attack_hit_box_direction()


func _on_moving_direction_changed() -> void:
	if get_moving_direction() == Vector2.ZERO or get_moving_direction() == get_facing_direction():
		return
	
	var sign_direction: Vector2 = Vector2(
		sign(get_moving_direction().x),
		sign(get_moving_direction().y)
	)
	
	if sign_direction == get_moving_direction():
		set_facing_direction(moving_direction)
	else:
		if sign_direction.x == get_facing_direction().x:
			set_facing_direction(Vector2(0, sign_direction.y))
		else:
			set_facing_direction(Vector2(sign_direction.x, 0))


func _on_animated_sprite_2d_animation_finished() -> void:
	if "attack".is_subsequence_of(animated_sprite.get_animation()):
		state_machine.set_state("Idle")
	elif "parry".is_subsequence_of(animated_sprite.get_animation()):
		state_machine.set_state("Block")
	elif "hurt".is_subsequence_of(animated_sprite.get_animation()):
		if hp == 0:
			die()
		else:
			state_machine.set_state("Idle")


func _on_animated_sprite_2d_frame_changed() -> void:
	if "attack".is_subsequence_of(animated_sprite.get_animation()):
		if animated_sprite.get_frame() == 1:
			_attack_effect()


func _on_hp_changed() -> void:
	pass
