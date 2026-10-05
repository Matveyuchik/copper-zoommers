extends Control

@onready var buttons_container = $Buttons
#@onready var selector_icon = $TextureRect
@onready var audio_player = $AudioStreamPlayer

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Verbinde jeden Button automatisch mit den Signalen für Fokus und Klick
	for button in buttons_container.get_children():
		if button is Button:
			button.focus_entered.connect(_on_button_focus_entered.bind(button))
			button.pressed.connect(_on_button_pressed.bind(button.name))
	
	# Beim Start des Menüs direkt den ersten Button fokussieren
	buttons_container.get_child(0).grab_focus()

func _on_button_focus_entered(current_button: Button):
	# 1. Sound abspielen beim Wechseln (außer beim allerersten Laden)
	if visible and not audio_player.playing:
		audio_player.play()
	
	# 2. Das Auswahl-Icon (Totenkopf) links neben den fokussierten Button setzen
	# Wir nehmen die Position des Buttons und ziehen etwas X ab, damit es links daneben steht
	#var target_x = current_button.global_position.x - selector_icon.size.x - 10
	# Y zentrieren wir auf die Höhe des Buttons
	#var target_y = current_button.global_position.y + (current_button.size.y / 2) - (selector_icon.size.y / 2)
	
	# Sofortige Platzierung (oder nutze ein Tween für flüssiges Gleiten)
	#selector_icon.global_position = Vector3(target_x, target_y, 0) # Falls 2D, nutze Vector2

func _on_button_pressed(button_name: String):
	# Logik, was passiert, wenn ein Button ausgewählt/gedrückt wird
	match button_name:
		"Play":
			SceneTransition.change_scene("res://scenes/level1.tscn")
		"OPTIONS":
			print("Öffne Optionen...")
		"Quit":
			get_tree().quit()
