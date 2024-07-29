extends Node2D

class_name ToolInventory

signal updated

const ITEM_MAX := 99
const STARTING_COUNT := 1 # TODO: Update to 0 when done testing
const POTION_ORDER: Array[ThrownProjectile.Type] = [
    ThrownProjectile.Type.POTION_WOOD,
    ThrownProjectile.Type.POTION_STONE,
    ThrownProjectile.Type.POTION_QUARTZ,
    ThrownProjectile.Type.POTION_OIL,
]
const SUMMON_ORDER: Array[EnemySpawner.EnemyType] = [
    EnemySpawner.EnemyType.TreeSprite,
    EnemySpawner.EnemyType.RockSprite,
    EnemySpawner.EnemyType.WindSprite,
    EnemySpawner.EnemyType.FireSprite
]

# We could do something nice and scalable
# Anyways here, have an array
# <3 - Logan
var potion_counts: Array[int]
var summon_counts: Array[int]

func _ready() -> void:
    for i in POTION_ORDER.size():
        potion_counts.append(STARTING_COUNT)
    for i in SUMMON_ORDER.size():
        summon_counts.append(STARTING_COUNT)

func get_potion_count(type: ThrownProjectile.Type) -> int:
    var index: int = POTION_ORDER.find(type)
    return potion_counts[index]

func set_potion_count(type: ThrownProjectile.Type, value: int) -> void:
    var index: int = POTION_ORDER.find(type)
    potion_counts[index] = clamp(value, 0, ITEM_MAX)
    updated.emit()

func add_potion_count(type: ThrownProjectile.Type, value: int) -> void:
    var new_count = get_potion_count(type) + value
    set_potion_count(type, new_count)

func get_potion_counts() -> Array[int]:
    return potion_counts

func get_summon_count(type: EnemySpawner.EnemyType) -> int:
    var index: int = SUMMON_ORDER.find(type)
    return summon_counts[index]

func set_summon_count(type: EnemySpawner.EnemyType, value: int) -> void:
    var index: int = SUMMON_ORDER.find(type)
    summon_counts[index] = clamp(value, 0, ITEM_MAX)
    updated.emit()

func add_summon_count(type: EnemySpawner.EnemyType, value: int) -> void:
    var new_count = get_summon_count(type) + value
    set_summon_count(type, new_count)

func get_summon_counts() -> Array[int]:
    return summon_counts
