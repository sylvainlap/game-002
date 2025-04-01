extends ItemList
class_name InventoryItemList

signal selected_item_id_changed

var selected_item_id: int = -1 : set = set_selected_item_id, get = get_selected_item_id


func _ready() -> void:
	selected_item_id_changed.connect(_on_selected_item_id_changed)


func set_selected_item_id(value: int) -> void:
	selected_item_id = value
	selected_item_id_changed.emit(selected_item_id)


func get_selected_item_id() -> int:
	return selected_item_id


func navigate_up() -> void:
	if get_item_count() > 0:
		set_selected_item_id(wrapi(selected_item_id - 1, 0, get_item_count()))
	else:
		set_selected_item_id(-1)


func navigate_down() -> void:
	if get_item_count() > 0:
		set_selected_item_id(wrapi(selected_item_id + 1, 0, get_item_count()))
	else:
		set_selected_item_id(-1)


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


func _update_selected_item(selected_item_id: int) -> void:
	if selected_item_id == -1:
		deselect_all()
	else:
		select(selected_item_id)

func _on_inventory_data_manager_item_added(item_amount: ItemAmount) -> void:
	update_item_display(item_amount)


func _on_inventory_data_manager_item_removed(item_amount: ItemAmount) -> void:
	update_item_display(item_amount)


func _on_selected_item_id_changed(selected_item_id: int) -> void:
	_update_selected_item(selected_item_id)


func _on_inventory_showed_changed(showed: bool) -> void:
	if showed && get_item_count() > 0:
		set_selected_item_id(0)
	else:
		set_selected_item_id(-1)
