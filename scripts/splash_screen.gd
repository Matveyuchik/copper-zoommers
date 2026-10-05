extends Control


@onready var player = $AudioStreamPlayer

func _ready():
	player.finished.connect(ended)
	
func ended():
	$Press.visible = true

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		if !is_inside_tree(): return
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
