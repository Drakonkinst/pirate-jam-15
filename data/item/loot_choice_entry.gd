extends LootEntry

class_name LootChoiceEntry

@export var entries: Array[LootEntry]

func add(drops: Dictionary) -> Dictionary:
    var choice: LootEntry = entries[randi() % entries.size()]
    return choice.add(drops)