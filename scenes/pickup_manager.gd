extends Node2D

class_name PickupManager

@export var pickup_scene: PackedScene
@export var pickup_parent: Node2D

@export var gold_texture: Texture2D
@export var fire_texture: Texture2D
@export var quartz_texture: Texture2D
@export var sap_texture: Texture2D
@export var fruit_texture: Texture2D

@export var gui_targets: Array[Node2D]

const PICKUP_ORDER: Array[Pickup.PickupType] = [
    Pickup.PickupType.GOLD,
    Pickup.PickupType.FIRE,
    Pickup.PickupType.QUARTZ,
    Pickup.PickupType.SAP,
    Pickup.PickupType.FRUIT,
]

var pickup_textures: Array[Texture2D]

func _ready() -> void:
    # Are there better ways to do this? Yes. However
    pickup_textures = [gold_texture, fire_texture, quartz_texture, sap_texture, fruit_texture]

func spawn_pickup_drop(type: Pickup.PickupType, pos: Vector2) -> Pickup:
    var pickup_obj = pickup_scene.instantiate()
    pickup_parent.add_child(pickup_obj)

    var pickup = pickup_obj as Pickup
    var index = PICKUP_ORDER.find(type, 0)
    var texture: Texture2D = pickup_textures[index]
    var target: Vector2 = gui_targets[index].global_position

    # print("Found texture ", texture, " for type ", Pickup.PickupType.keys()[type])
    assert(texture != null)

    pickup.init(type, texture, target, pos)
    return pickup