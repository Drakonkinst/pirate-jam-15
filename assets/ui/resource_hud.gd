extends Control



@onready var gold_count: Label = %GoldCount
@onready var fire_crystal_count: Label = %FireCrystalCount
@onready var quartz_crystal_count: Label = %QuartzCount
@onready var amber_sap_count: Label = %AmberSapCount
@onready var fruit_count: Label = %FruitCount



var player_resources: PlayerResources = null

func setup():
    player_resources = GlobalVariables.player_resources


func _process(_delta):
    # Should probably use the .changed signal on the player resource instead
    if player_resources == null:
        setup()
    else:
        update_count_labels()


func update_count_labels():
    gold_count.text =           str(player_resources.gold)
    fire_crystal_count.text =   str(player_resources.fire_crystals)
    quartz_crystal_count.text = str(player_resources.quartz)
    amber_sap_count.text =      str(player_resources.amber_sap)
    fruit_count.text =          str(player_resources.fruit)


