extends StaticBody3D

@onready var tnt_item = load("res://items/tnt_item.tres")

func interact():
	GlobalInventory.data.add_item(tnt_item)
