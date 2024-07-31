extends HBoxContainer

class_name CraftingMenuListing

# Signals for playing effects when crafting begins, progresses, or ends
signal crafting_start
signal crafting_failed
signal crafting_timer_down
signal crafting_end

@onready var crafting_timer: Timer = %CraftingTimer
@onready var craft_button: Button = %Button

@export var crafting_data: CraftingData
@export var recipe_name: String
@onready var crafting_time: float = crafting_data.crafting_time

@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]

@export var image: CompressedTexture2D
@onready var craft_audio: AudioRandomizer = $CraftAudio
@onready var insufficient_resources_audio: AudioRandomizer = $InsufficientResources


@export var fire_crystal: CompressedTexture2D
@export var shadow_sand: CompressedTexture2D
@export var leaf: CompressedTexture2D
@export var rock: CompressedTexture2D
@export var fruit: CompressedTexture2D
@export var quartz: CompressedTexture2D
@export var recipe_listing: PackedScene

static var is_crafting := false

func _ready():
    setup()

func setup():
    %ItemLabel.text = recipe_name
    %ItemTexture.texture = image
    show_recipe()

func show_recipe():
    var container = %RecipeContainer
    for i in range(0,crafting_data.recipe_list.size()):
        var current_recipe_item = crafting_data.recipe_list[i]

        var new_listing = recipe_listing.instantiate()
        
        new_listing.get_node("Count").text = str(current_recipe_item.count)

        var new_icon_texture: CompressedTexture2D
        match current_recipe_item.resource_type:
            Pickup.PickupType.SHADOWSAND:
                new_icon_texture = shadow_sand
            Pickup.PickupType.FIRE:
                new_icon_texture = fire_crystal 
            Pickup.PickupType.QUARTZ:
                new_icon_texture = quartz 
            Pickup.PickupType.SAP:
                new_icon_texture = leaf
            Pickup.PickupType.FRUIT:
                new_icon_texture = fruit 
            Pickup.PickupType.STONE:
                new_icon_texture = rock 
            _:
                new_icon_texture = rock
        new_listing.get_node("IconContainer").get_node("Icon").texture = new_icon_texture
        container.add_child(new_listing)

func _on_craft_button_pressed():
    start_crafting()

func start_crafting():
    if is_crafting:
        return
    if try_expend_resources() == false:
        crafting_failed.emit()
        return
    is_crafting = true
    crafting_start.emit()
    crafting_time = crafting_data.crafting_time
    craft_button.text = str(crafting_time)
    
    crafting_timer.wait_time = 1
    crafting_timer.start()

func try_expend_resources() -> bool:
    var crafting_recipe = crafting_data.recipe_list
    var player_resources = player.player_resources

    # Check if player has enough resources 
    for i in range(0,crafting_recipe.size()):
        var crafting_component = crafting_recipe[i]
        var cost = crafting_component.count
        var held_resource = player_resources.get_count(crafting_component.resource_type)
        if cost > held_resource:
            print("Not enough resources")
            insufficient_resources_audio.play_random()
            return false

    # Reduce resources if so
    for i in range(0,crafting_recipe.size()):
        var crafting_component = crafting_recipe[i]
        var cost = crafting_component.count
        var resource_type = crafting_component.resource_type
        player_resources.set_count(resource_type,player_resources.get_count(resource_type) - cost)
        
    return true

func end_crafting():
    is_crafting = false
    crafting_end.emit()
    craft_button.text = "Craft"
    craft_audio.play_random()
    give_item()

func give_item():
    var tool_inv = GlobalVariables.get_toolbar().tool_inventory
    # Dont mind the below code it does the thing
    var proj_type: ThrownProjectile.Type = 0 as ThrownProjectile.Type
    var summon_type: EnemySpawner.EnemyType = 0 as EnemySpawner.EnemyType
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
