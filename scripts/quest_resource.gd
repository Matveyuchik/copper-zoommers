class_name QuestResource
extends Resource

@export var quest_id: String = ""
@export var title: String = ""
@export_multiline var description: String = ""

# Текущий прогресс и цель (например, собрать 5 яблок)
@export var current_amount: int = 0
@export var target_amount: int = 1

@export var is_accepted: bool = false
@export var is_completed: bool = false

func check_completion() -> bool:
	if current_amount >= target_amount:
		is_completed = true
	return is_completed
