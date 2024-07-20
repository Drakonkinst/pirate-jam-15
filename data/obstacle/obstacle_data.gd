extends Resource

class_name ObstacleData

enum Type {
    UNKNOWN, TREE, ROCK, TORCH, OIL_SPILL, SAPLING
}

@export var id: Type
@export var health: int = 10
@export var is_flammable: bool = false
@export var should_use_burnt_texture: bool = false
@export var can_pass_through: bool = false

# TODO
@export var loot: LootEntry