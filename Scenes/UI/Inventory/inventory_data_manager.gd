extends Node2D
class_name InventoryDataManager

signal item_added
signal item_removed

var item_amount_list: Array[ItemAmount] = []


func _ready() -> void:
	EVENTS.object_collected.connect(_on_EVENTS_object_collected)


func _find_item_idx(item_data: ItemData) -> int:
	for i in range(item_amount_list.size()):
		if item_amount_list[i].item_data == item_data:
			return i

	return -1


func _append_item(item_data: ItemData, amount: int = 1) -> void:
	var idx = _find_item_idx(item_data)
	var item_amount = null
	
	if idx == -1:
		item_amount = ItemAmount.new(amount, item_data)
		item_amount_list.append(item_amount)
	else:
		item_amount = item_amount_list[idx]
		item_amount.amount += amount
	
	item_added.emit(item_amount)


func _remove_item(item_data: ItemData, amount: int = 1) -> void:
	var idx = _find_item_idx(item_data)
	var item_amount = null
	
	if idx == -1:
		push_error("%s cound not be removed from the list." % item_data.item_name)
	else:
		item_amount = item_amount_list[idx]
		item_amount.amount -= amount

		item_removed.emit(item_amount_list[idx])

		if item_amount_list[idx].amount < 0:
			item_amount_list.remove_at(idx)


func _on_EVENTS_object_collected(object: Node2D) -> void:
	if object is Item:
		_append_item(object.item_data)
