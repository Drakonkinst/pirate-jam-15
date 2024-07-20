extends Node2D

# Uses inherited scenes to keep child components constant for all types of obstacles
class_name Obstacle

signal destroyed

# Some objects can be tramsuted which should overlay their shape with a texture
enum TransmutedMaterial {
	DEFAULT, WOOD, STONE, QUARTZ
}

# TODO: Reference a "Stats" resource for starting health, resource drops, whether it can be moved through, and whether it is transmutable

var tile: GridTile
var transmuted: TransmutedMaterial = TransmutedMaterial.DEFAULT

@onready var health: Health = $Health
@onready var model: ObstacleModel = $ObstacleModel1 # Selects the default obstacle model in case there are no extras

@export var data: ObstacleData
@export var alternate_models: Array[ObstacleModel] # Optional array. If there are variations of the same model, can list them all here to choose randomly

func choose_model() -> void:
	if alternate_models.size() <= 0:
		return
	var choice: int = randi() % alternate_models.size()
	for i in range(alternate_models.size()):
		alternate_models[i].visible = i == choice
	model = alternate_models[choice]

func init_model() -> void:
	choose_model()
	model.set_flaming(false)

	# For demo
	if randf() < 0.5 and data.is_flammable:
		model.set_flaming(true)

func set_tile(obj: GridTile) -> void:
	tile = obj

func damage(value: int) -> void:
	health.set_health(health.health - value)
	if health.health <= 0:
		destroyed.emit()
		queue_free()

func _ready() -> void:
	init_model()



