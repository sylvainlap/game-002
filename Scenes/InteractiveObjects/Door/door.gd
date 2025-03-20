extends StaticBody2D
class_name Door


func _ready() -> void:
	EVENTS.room_finished.connect(_on_room_finished)


func open() -> void:
	$DoorSprite.play("open")
	$GridSprite.play("unlock")
	$CollisionShape2D.set_disabled(true)


func _on_room_finished() -> void:
	open()
	
