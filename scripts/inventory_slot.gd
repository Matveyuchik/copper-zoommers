extends Resource
class_name InventorySlot

@export var item: Item
@export var quantity: int = 0

func clear() -> void:
	item = null 
	quantity = 0

func remove(amount: int = 1) -> void:
	if quantity - amount <= 0:
		clear()
		return
	quantity-=amount
