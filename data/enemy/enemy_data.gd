extends Resource

class_name EnemyData

@export var type: EnemySpawner.EnemyType
@export var health: int
@export var attack_damage: int
@export var attack_frequency: float
@export var move_speed: float = 10000.0
@export var loot: LootEntry
@export var flammable: bool = true
