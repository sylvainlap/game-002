extends ItemList
class_name InventoryItemList


func _find_item_in_list(item_amount: ItemAmount) -> int:
	for i in range(get_item_count()):
		if get_item_metadata(i) == item_amount:
			return i
	
	return -1


func update_item_display(item_amount: ItemAmount) -> void:
	var idx = _find_item_in_list(item_amount)
	var text = "%s: %d" % [item_amount.item_data.item_name, item_amount.amount]
	
	if idx == -1:
		add_item(text, item_amount.item_data.inventory_texture, true)
		idx = get_item_count() -1
		set_item_metadata(idx, item_amount)
	else:
		if item_amount.amount <= 0:
			remove_item(idx)
		else:
			set_item_text(idx, text)


func _on_inventory_data_manager_item_added(item_amount: ItemAmount) -> void:
	update_item_display(item_amount)


func _on_inventory_data_manager_item_removed(item_amount: ItemAmount) -> void:
	update_item_display(item_amount)
