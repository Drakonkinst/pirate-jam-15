extends Resource

class_name ObstacleData

@export var id: Obstacle.Type
@export var transmuted_base_type: Obstacle.TransmutedState
@export var health: int = 10
@export var invulnerable: bool = false
@export var size_multiplier: float = 1 # Multiplied with the material when transmutated
@export var is_flammable: bool = false
@export var should_use_burnt_texture: bool = false
@export var can_pass_through: bool = false
@export var can_transform: bool = true

@export var loot: LootEntry
