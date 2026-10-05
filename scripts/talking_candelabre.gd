extends Sprite3D

@onready var resource = load("res://dialogues/candelabre.dialogue")
@onready var area: Area3D = $Area3D

func _ready() -> void:
	area.area_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node3D):
	if body.name == "Player":
		DialogueManager.show_dialogue_balloon(resource, "start")
