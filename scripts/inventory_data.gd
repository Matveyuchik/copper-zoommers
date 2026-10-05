extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)

@export var slots: Array[InventorySlot]
@export var max_size: int = 12

func initialize_inventory(size: int = 12) -> void:
	max_size = size
	slots.clear()
	for i in range(size):
		slots.append(InventorySlot.new())

func add_item(new_item: Item, amount: int = 1) -> int:
	if new_item == null or amount <= 0:
		return amount
	
	var remaining = amount
	
	# First pass: try to stack with existing items
	for slot in slots:
		if slot.item == new_item and slot.quantity < new_item.max_quantity:
			var available_size = new_item.max_quantity - slot.quantity
			var to_add = min(remaining, available_size)
			slot.quantity += to_add
			remaining -= to_add
			if remaining <= 0:
				inventory_updated.emit(self)
				return 0
	
	# Second pass: fill empty slots
	for slot in slots:
		if slot.item == null:
			var to_add = min(remaining, new_item.max_quantity)
			slot.item = new_item
			slot.quantity = to_add
			remaining -= to_add
			if remaining <= 0:
				inventory_updated.emit(self)
				return 0
	
	# If we get here, inventory is full
	inventory_updated.emit(self)
	return remaining

# Use item name as identifier (since you're using @export var name)
func has_item(item_name: String, amount: int = 1) -> bool:
	var count = 0
	for slot in slots:
		if slot.item and slot.item.name == item_name:
			count += slot.quantity
			if count >= amount:
				return true
	return false

# Check by item reference (more reliable)
func has_item_ref(item: Item, amount: int = 1) -> bool:
	if item == null:
		return false
	var count = 0
	for slot in slots:
		if slot.item == item:
			count += slot.quantity
			if count >= amount:
				return true
	return false

# Remove by item name
func remove_item(item_name: String, amount: int = 1) -> bool:
	if amount <= 0:
		return true
	
	var remaining: int = amount
	
	for slot in slots:
		if slot.item and slot.item.name == item_name:
			if slot.quantity > remaining:
				slot.remove(remaining)
				inventory_updated.emit(self)
				return true
			else:
				remaining -= slot.quantity
				slot.clear()
			
			if remaining <= 0:
				inventory_updated.emit(self)
				return true
	
	# Not enough items found
	return false

# Remove by item reference (more reliable)
func remove_item_ref(item: Item, amount: int = 1) -> bool:
	if item == null:
		return false
	return remove_item(item.name, amount)

func get_item_count(item_name: String) -> int:
	var total = 0
	for slot in slots:
		if slot.item and slot.item.name == item_name:
			total += slot.quantity
	return total

func get_item_count_ref(item: Item) -> int:
	if item == null:
		return 0
	return get_item_count(item.name)

func is_full() -> bool:
	for slot in slots:
		if slot.item == null:
			return false
	return true

func get_empty_slot_count() -> int:
	var count = 0
	for slot in slots:
		if slot.item == null:
			count += 1
	return count

func clear_inventory() -> void:
	for slot in slots:
		slot.clear()
	inventory_updated.emit(self)

func swap_slots(index_a: int, index_b: int) -> void:
	if index_a < 0 or index_a >= slots.size() or index_b < 0 or index_b >= slots.size():
		return
	
	var temp = slots[index_a]
	slots[index_a] = slots[index_b]
	slots[index_b] = temp
	inventory_updated.emit(self)

func can_add_item(item: Item, amount: int = 1) -> bool:
	if item == null or amount <= 0:
		return false
	
	var remaining = amount
	
	# Check existing stacks
	for slot in slots:
		if slot.item == item and slot.quantity < item.max_quantity:
			var available = item.max_quantity - slot.quantity
			remaining -= min(remaining, available)
			if remaining <= 0:
				return true
	
	# Check empty slots
	for slot in slots:
		if slot.item == null:
			remaining -= min(remaining, item.max_quantity)
			if remaining <= 0:
				return true
	
	return false

# Get all unique items with their total quantities
func get_inventory_summary() -> Dictionary:
	var summary = {}
	for slot in slots:
		if slot.item != null:
			var item_name = slot.item.name
			if summary.has(item_name):
				summary[item_name] += slot.quantity
			else:
				summary[item_name] = slot.quantity
	return summary

# Find first slot containing a specific item
func find_slot_by_item(item: Item) -> int:
	for i in range(slots.size()):
		if slots[i].item == item:
			return i
	return -1

# Find first slot containing item by name
func find_slot_by_name(item_name: String) -> int:
	for i in range(slots.size()):
		if slots[i].item and slots[i].item.name == item_name:
			return i
	return -1
