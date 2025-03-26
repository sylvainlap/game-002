extends Control
class_name Inventory

var item_amount_list: Array[ItemAmount] = []


class ItemAmount:
	var amount: int = 0
	var item_data: ItemData = null
	
	func _init(_amount: int, _item_data: ItemData) -> void:
		amount = _amount
		item_data = _item_data


func _ready() -> void:
	EVENTS.object_collected.connect(_on_EVENTS_object_collected)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		_print_inventory()


func _find_item_idx(item_data: ItemData) -> int:
	for i in range(item_amount_list.size()):
		if item_amount_list[i].item_data == item_data:
			return i

	return -1


func _append_item(item_data: ItemData, amount: int = 1) -> void:
	var idx = _find_item_idx(item_data)
	
	if idx == -1:
		item_amount_list.append(ItemAmount.new(amount, item_data))
	else:
		item_amount_list[idx].amount += amount


func _remove_item(item_data: ItemData, amount: int = 1) -> void:
	var idx = _find_item_idx(item_data)
	
	if idx == -1:
		push_error("%s cound not be removed from the list." % item_data.item_name)
	else:
		item_amount_list[idx].amount -= amount
		
		if item_amount_list[idx].amount < 0:
			item_amount_list.remove_at(idx)


func _print_inventory() -> void:
	print("--- INVENTORY CONTENT ---")
	print("")
	for item_amount in item_amount_list:
		print(item_amount.item_data.item_name + ": " + str(item_amount.amount))
	print("")
	print("-------------------------")
	print("")


func _on_EVENTS_object_collected(object: Node2D) -> void:
	if object is Item:
		_append_item(object.item_data)
