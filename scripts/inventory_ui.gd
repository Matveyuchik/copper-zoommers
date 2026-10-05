extends PanelContainer

@onready var slot_grid: GridContainer = $GridContainer
const SLOT_UI_SCENE = preload("res://scenes/slot_ui.tscn")

func _ready() -> void:
	hide()

### 1. Connect to the custom signal we made in InventoryData

	GlobalInventory.data.inventory_updated.connect(populate_grid)

# 2. Draw the inventory for the very first time

	populate_grid(GlobalInventory.data)

func populate_grid(inventory_data: InventoryData) -> void:

### Clear out any old visual slots first

	for child in slot_grid.get_children():
		child.queue_free()

### Create a visual UI slot for every data slot in our resource

	for slot_data in inventory_data.slots:
		var slot_ui = SLOT_UI_SCENE.instantiate()
		slot_grid.add_child(slot_ui)
		slot_ui.update_slot_display(slot_data)

func _unhandled_input(event: InputEvent) -> void:
	if !is_inside_tree(): return
	if event.is_action_pressed("action_inventory"):
		if visible:
			$AnimationPlayer.play("hide")
			await $AnimationPlayer.animation_finished
			hide()
		else:
			show()
			$AnimationPlayer.play("show")
			await $AnimationPlayer.animation_finished
