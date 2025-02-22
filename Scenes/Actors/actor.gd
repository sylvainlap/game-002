extends CharacterBody2D
class_name Actor

@onready var animated_sprite: Node = get_node("AnimatedSprite2D")
@onready var attack_hit_box: Node = get_node("AttackHitBox")

signal state_changed
signal moving_direction_changed
signal facing_direction_changed

enum STATE {
	IDLE,
	MOVE,
	ATTACK,
}

const SPEED := 300.0

var moving_direction := Vector2.ZERO: set = set_moving_direction, get = get_moving_direction
var facing_direction := Vector2.DOWN: set = set_facing_direction, get = get_facing_direction

var direction_dict := {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"up": Vector2.UP,
	"down": Vector2.DOWN,
}

var state := STATE.IDLE: set = set_state, get = get_state


func set_state(new_state: STATE) -> void:
	if new_state != state:
		state = new_state
		state_changed.emit()

func get_state() -> STATE:
	return state


func set_moving_direction(new_moving_direction: Vector2) -> void:
	if new_moving_direction != moving_direction:
		moving_direction = new_moving_direction
		moving_direction_changed.emit()


func get_moving_direction() -> Vector2:
	return moving_direction


func set_facing_direction(new_facing_direction: Vector2) -> void:
	if new_facing_direction != facing_direction:
		facing_direction = new_facing_direction
		facing_direction_changed.emit()


func get_facing_direction() -> Vector2:
	return facing_direction


func _ready() -> void:
	state_changed.connect(_on_state_changed)
	moving_direction_changed.connect(_on_moving_direction_changed)
	facing_direction_changed.connect(_on_facing_direction_changed)
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	animated_sprite.frame_changed.connect(_on_animated_sprite_2d_frame_changed)


func _physics_process(_delta: float) -> void:
	velocity = moving_direction * SPEED
	move_and_slide()


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
	var state_name := ""
	
	match(state):
		STATE.IDLE:
			state_name = "idle"
		STATE.MOVE:
			state_name = "move"
		STATE.ATTACK:
			state_name = "attack"
		
	animated_sprite.play(state_name + "_" + direction_name)


func _update_attack_hit_box_direction() -> void:
	var angle = get_facing_direction().angle()
	
	attack_hit_box.set_rotation_degrees(rad_to_deg(angle) - 90)


func _attack_effect() -> void:
	var bodies_array = attack_hit_box.get_overlapping_bodies()
	
	for body in bodies_array:
		if body.has_method("destroy"):
			body.destroy()


func _on_state_changed() -> void:
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
		set_state(STATE.IDLE)


func _on_animated_sprite_2d_frame_changed() -> void:
	if "attack".is_subsequence_of(animated_sprite.get_animation()):
		if animated_sprite.get_frame() == 1:
			_attack_effect()
