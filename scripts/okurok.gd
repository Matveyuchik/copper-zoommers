extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.

@onready var camera: Camera3D

var target_player = null

# Ваш файл диалога
var resource = load("res://dialogues/okurok.dialogue")

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("camera")
	
func _process(delta: float) -> void:
	if !camera: return
	
	# 1. Flatten the positions to the XZ plane to ignore height differences
	var enemy_pos_2d = Vector2(global_position.x, global_position.z)
	var cam_pos_2d = Vector2(camera.global_position.x, camera.global_position.z)
	
	# 2. Vector pointing from enemy to camera
	var to_cam = cam_pos_2d - enemy_pos_2d
	
	# 3. Vector pointing forward from enemy (Godot 4 forward is -basis.z)
	var forward_3d = -global_transform.basis.z
	var forward_2d = Vector2(forward_3d.x, forward_3d.z).normalized()
	
	# 4. Get the angle between them (-PI to PI)
	var angle = forward_2d.angle_to(to_cam)
	
	# 5. Convert -PI to PI range into a clean 0 to 2*PI range
	if angle < 0:
		angle += 2 * PI
		
	# 6. Shift by half a slice (PI / 8) so that "Front" animation is centered
	# This prevents the sprite from snapping angles right as the player faces them dead-on
	var shifted_angle = angle + (PI / 4.0)
	if shifted_angle >= 2 * PI:
		shifted_angle -= 2 * PI
		
	# 7. Convert angle to an index from 0 to 7 (8 directions)
	var anim_index = int(floor(shifted_angle / (PI / 2.0)))
	
	# 8. Convert index to string to match your animation names ("0" to "7")
	var anim_name = str(anim_index)
	
	# 9. Play only if it changed
	if $AnimatedSprite3D.animation != anim_name:
		$AnimatedSprite3D.play(anim_name)

	# Если игрок начал диалог, плавно поворачиваемся к нему
	if target_player:
		# Получаем позицию игрока, но игнорируем высоту (Y), чтобы NPC не задирал голову вверх/вниз
		var target_pos: Vector3 = target_player.global_position
		target_pos.y = global_position.y
		
		# Создаем целевую трансформацию (куда нужно смотреть)
		#var target_transform: Transform3D = global_transform.looking_at(target_pos, Vector3.UP)
		
		# Плавно интерполируем текущий поворот к целевому
		#global_transform.basis = global_transform.basis.slerp(target_transform.basis, 0.5 * delta)



# Метод взаимодействия, который будет вызывать Игрок
func interact():
	if not is_inside_tree(): return
	target_player = get_tree().get_first_node_in_group("player")
	# Проверяем, загрузился ли файл, чтобы избежать вылета игры
	if resource:
		# Запускаем диалог с самого начала (титул "this_is_a_node_title" или "start")
		# Замените "start" на то название ветки, которое написано у вас в файле okurok.dialogue
		DialogueManager.show_dialogue_balloon(resource, "start")
	else:
		print("Ошибка: Файл диалога не найден!")
