extends HBoxContainer

class_name CraftingMenuListing

# Signals for playing effects when crafting begins, progresses, or ends
signal crafting_start
signal crafting_timer_down
signal crafting_end

@onready var crafting_timer: Timer = %CraftingTimer
@onready var craft_button: Button = %Button

@export var crafting_data: CraftingData
@export var recipe_name: String
@onready var crafting_time: float = crafting_data.crafting_time

@export var image: CompressedTexture2D
@onready var craft_audio: AudioRandomizer = $CraftAudio

func _ready():
    setup()

func setup():
    %ItemLabel.text = recipe_name
    %ItemTexture.texture = image

func _on_craft_button_pressed():
    start_crafting()

func start_crafting():
    crafting_start.emit()
    crafting_time = crafting_data.crafting_time
    craft_button.text = str(crafting_time)

    crafting_timer.wait_time = 1
    crafting_timer.start()

func end_crafting():
    crafting_end.emit()
    craft_button.text = "Craft"
    craft_audio.play_random()
    give_item()

func give_item():
    var tool_inv = GlobalVariables.get_toolbar().tool_inventory
    # Dont mind the below code it does the thing
    var proj_type: ThrownProjectile.Type = -1
    var summon_type: EnemySpawner.EnemyType = -1
    match crafting_data.item:
        CraftingData.ItemType.POTION_WOOD:
            proj_type = ThrownProjectile.Type.POTION_WOOD
        CraftingData.ItemType.POTION_STONE:
            proj_type = ThrownProjectile.Type.POTION_STONE
        CraftingData.ItemType.POTION_QUARTZ:
            proj_type = ThrownProjectile.Type.POTION_QUARTZ
        CraftingData.ItemType.POTION_OIL:
            proj_type = ThrownProjectile.Type.POTION_OIL
        CraftingData.ItemType.ROCK_SPRITE:
            summon_type = EnemySpawner.EnemyType.RockSprite
        CraftingData.ItemType.WIND_SPRITE:
            summon_type = EnemySpawner.EnemyType.WindSprite
        CraftingData.ItemType.WOOD_SPRITE:
            summon_type = EnemySpawner.EnemyType.TreeSprite
        CraftingData.ItemType.FIRE_SPRITE:
            summon_type = EnemySpawner.EnemyType.FireSprite
    if proj_type >= 0:
        tool_inv.add_potion_count(proj_type, 1)
    elif summon_type >= 0:
        tool_inv.add_summon_count(summon_type, 1)


func _on_crafting_timer_timeout():
    if crafting_time > 1:
        #Decrement timer
        crafting_time -= 1
        craft_button.text = str(crafting_time)
        crafting_timer_down.emit()

        crafting_timer.wait_time = 1
        crafting_timer.start()
    else:
        # Drop new item at cauldron for pickup
        end_crafting()
