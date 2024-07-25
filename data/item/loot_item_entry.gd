extends LootEntry

class_name LootItemEntry

@export var item: Pickup.PickupType
@export var min_count: int
@export var max_count: int

func add(drops: Dictionary) -> Dictionary:
    var amount = randi_range(min_count, max_count)
    if amount <= 0:
        return drops

    if item not in drops:
        drops[item] = 0
        drops[item] += amount
    return drops
