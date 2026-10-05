extends CharacterBody3D

# Konstanten für die Bewegungseigenschaften
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var ray = $RayCast3D
@onready var quest_canva = $Quest
@onready var quest_panel = $Quest/Panel

func _ready() -> void:
	QuestManager.quest_accepted.connect(_on_quest_accepted)
	QuestManager.quest_completed.connect(_on_quest_complete)
	
func _on_quest_accepted(quest: QuestResource):
	if not is_inside_tree(): return
	quest_canva.show()
	quest_panel.get_child(0).text = "QUEST ACCEPTED"
	quest_panel.get_child(1).text = quest.title
	quest_panel.get_child(2).text = quest.description
	
	var timer = get_tree().create_timer(2)
	
	await timer.timeout
	quest_canva.visible = false

func _on_quest_complete(quest: QuestResource):
	if not is_inside_tree(): return
	quest_canva.show()
	quest_panel.get_child(0).text = "QUEST COMPLETED"
	quest_panel.get_child(1).text = quest.title
	quest_panel.get_child(2).text = quest.description
	
	var timer = get_tree().create_timer(2)
	
	await timer.timeout
	quest_canva.visible = false

func _physics_process(delta: float) -> void:
	# 1. Schwerkraft hinzufügen, wenn der Charakter in der Luft ist
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Springen verarbeiten (fordert die Aktion "ui_accept" / Leertaste)
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Eingabe-Richtung abfragen (Standard-Pfeiltasten / WASD)
	# input_dir ist ein Vector2 (X für links/rechts, Y für vor/zurück)
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Richtung in den 3D-Raum umrechnen (Z-Achse ist in 3D vor/zurück)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		# Wenn Tasten gedrückt werden, Geschwindigkeit setzen
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Wenn keine Taste gedrückt wird, sanft abbremsen (Interpolation)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# 4. Die Bewegung ausführen und Kollisionen berechnen
	move_and_slide()

	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x - event.relative.y * 0.005, -PI/4, PI/4)
		
	if event.is_action_pressed("action_interact") and ray.get_collider() && ray.get_collider().has_method("interact"):
		ray.get_collider().interact();
