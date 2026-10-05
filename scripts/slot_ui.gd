extends PanelContainer

@onready var icon: TextureRect = $Icon
@onready var quantity: Label = $QuantityLabel

func update_slot_display(slot_data: InventorySlot) -> void:
	if slot_data and slot_data.item:
		icon.texture = slot_data.item.icon
		icon.show()
		
		if slot_data.quantity > 1:
			quantity.text = str(slot_data.quantity)
		else:
			quantity.hide()
	else:
		icon.texture = null
		icon.hide()
		quantity.hide()
