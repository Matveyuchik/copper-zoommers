extends Node

# Сигналы для обновления интерфейса
signal quest_accepted(quest: QuestResource)
signal quest_updated(quest: QuestResource)
signal quest_completed(quest: QuestResource)

# Хранилище всех квестов в игре: {"quest_id": QuestResource}
var quests: Dictionary = {}

func accept_quest(quest: QuestResource) -> void:
	if not quests.has(quest.quest_id):
		quest.is_accepted = true
		quests[quest.quest_id] = quest
		quest_accepted.emit(quest)

func advance_quest(quest_id: String, amount: int = 1) -> void:
	if quests.has(quest_id):
		var quest: QuestResource = quests[quest_id]
		if not quest.is_completed:
			quest.current_amount += amount
			quest_updated.emit(quest)
			
			if quest.check_completion():
				quest_completed.emit(quest)
