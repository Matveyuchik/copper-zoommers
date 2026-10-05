extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	# Hide the rect initially so it doesn't block processing
	color_rect.visible = false

func change_scene(target_scene: String) -> void:
	# 1. Show the rect and freeze the current screen state
	color_rect.visible = true
	
	# 2. Melt the current screen down into total blackness
	animation_player.play("modulate")
	await animation_player.animation_finished
	
	# 3. Swap the level instantly behind the black screen
	get_tree().change_scene_to_file(target_scene)
	
	# 4. Hide the overlay immediately so the new level snaps into view instantly
	color_rect.visible = false
	animation_player.play("RESET") 
