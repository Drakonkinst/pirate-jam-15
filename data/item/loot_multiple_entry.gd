extends LootEntry

class_name LootMultipleEntry

@export var entries: Array[LootEntry]

func add(drops: Dictionary) -> Dictionary:
    var result = drops
    for entry in entries:
        result = entry.add(result)
    return result