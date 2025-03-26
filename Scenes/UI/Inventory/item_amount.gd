extends Object
class_name ItemAmount

var amount: int = 0
var item_data: ItemData = null


func _init(_amount: int, _item_data: ItemData) -> void:
	amount = _amount
	item_data = _item_data
