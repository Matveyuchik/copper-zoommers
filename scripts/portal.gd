extends Sprite3D

@export var scene_in: String
@export var scene_out: String
@export var reverse: bool

@onready var area: Area3D = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	if !is_inside_tree(): return
	if body.is_in_group("player"):
		if reverse:
			SceneTransition.change_scene(scene_out)
		else:
			SceneTransition.change_scene(scene_in)
