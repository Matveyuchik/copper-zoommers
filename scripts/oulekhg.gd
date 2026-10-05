extends CharacterBody3D

@onready var resource = load("res://dialogues/oulekhg.dialogue")

func interact():
	if not is_inside_tree(): return
	# Проверяем, загрузился ли файл, чтобы избежать вылета игры
	if resource:
		# Запускаем диалог с самого начала (титул "this_is_a_node_title" или "start")
		# Замените "start" на то название ветки, которое написано у вас в файле okurok.dialogue
		DialogueManager.show_dialogue_balloon(resource, "start")
	else:
		print("Ошибка: Файл диалога не найден!")
