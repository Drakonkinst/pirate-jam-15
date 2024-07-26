extends Resource

class_name SpawnData

enum RowPosition {
	First,
	Second,
	Third,
	Fourth,
	Fifth,
	Random,
}


@export var spawn_time: float
@export var spawn_type: EnemySpawner.EnemyType = EnemySpawner.EnemyType.ShadowSprite
@export var row: RowPosition = RowPosition.Random
