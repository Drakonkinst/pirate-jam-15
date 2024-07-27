extends Node2D

class_name ToolInventory

const ITEM_MAX := 99
const POTION_ORDER: Array[ThrownProjectile.Type] = [
    ThrownProjectile.Type.POTION_WOOD,
    ThrownProjectile.Type.POTION_STONE,
    ThrownProjectile.Type.POTION_QUARTZ,
    ThrownProjectile.Type.POTION_OIL,
]
# TODO: Make another one for summons

# We could do something nice and scalable
# Anyways here, have an array
var potion_counts: Array[int]
var summon_counts: Array[int]

func _ready() -> void:
    for i in POTION_ORDER.size():
        potion_counts.append(0)
    # TODO: init summon counts
    for i in 4:
        summon_counts.append(0)

func get_potion_count(type: ThrownProjectile.Type) -> int:
    var index: int = POTION_ORDER.find(type)
    return potion_counts[index]

func set_potion_count(type: ThrownProjectile.Type, value: int) -> void:
    var index: int = POTION_ORDER.find(type)
    potion_counts[index] = clamp(value, 0, ITEM_MAX)

func add_potion_count(type: ThrownProjectile.Type, value: int) -> void:
    var new_count = get_potion_count(type) + value
    set_potion_count(type, new_count)

func get_potion_counts() -> Array[int]:
    return potion_counts

# TODO: Add methods for summons

func get_summon_counts() -> Array[int]:
    return summon_counts