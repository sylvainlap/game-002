extends Resource
class_name ItemData

enum DAMAGE_TYPE {
	HP,
	MP
}

@export var damage_type: DAMAGE_TYPE = DAMAGE_TYPE.HP
@export var damage: int = 0
@export var item_name: String = ""
@export var description: String = ""
@export var price: int = -1
@export var world_texture: Texture = null
@export var inventory_texture: Texture = null
