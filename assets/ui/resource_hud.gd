extends Control

class_name ResourceHud

@onready var gold_count: Label = %GoldCount
@onready var fire_crystal_count: Label = %FireCrystalCount
@onready var quartz_crystal_count: Label = %QuartzCount
@onready var amber_sap_count: Label = %AmberSapCount
@onready var fruit_count: Label = %FruitCount
@onready var stone_count: Label = %StoneCount
@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]

func _process(_delta):
    # Should probably use the .changed signal on the player resource instead
    # TODO: Yeah lol
    update_count_labels()

func update_count_labels():
    gold_count.text = _get_label(Pickup.PickupType.GOLD)
    fire_crystal_count.text = _get_label(Pickup.PickupType.FIRE)
    quartz_crystal_count.text = _get_label(Pickup.PickupType.QUARTZ)
    amber_sap_count.text = _get_label(Pickup.PickupType.SAP)
    fruit_count.text = _get_label(Pickup.PickupType.FRUIT)

func _get_label(type: Pickup.PickupType) -> String:
    return str(player.player_resources.get_count(type))


