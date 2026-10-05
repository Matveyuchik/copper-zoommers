extends Node

### This holds the active inventory data instance

var data: InventoryData

func _ready() -> void:
	
### Create a new instance of your inventory data
	
	data = InventoryData.new()

### Initialize it with 12 slots (or 36 for Minecraft style)

	data.initialize_inventory(12)
