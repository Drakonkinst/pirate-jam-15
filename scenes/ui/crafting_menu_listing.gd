extends HBoxContainer

class_name CraftingMenuListing

# Signals for playing effects when crafting begins, progresses, or ends
signal crafting_start
signal crafting_timer_down
signal crafting_end

@onready var crafting_timer: Timer = %CraftingTimer
@onready var craft_button: Button = %Button


@export var crafting_data: CraftingData
@onready var crafting_time: float = crafting_data.crafting_time


@export var quartz_img: CompressedTexture2D
@export var stone_img: CompressedTexture2D
@export var wood_img: CompressedTexture2D
@export var oil_img: CompressedTexture2D

@export var ally_img: CompressedTexture2D



func _ready():
	setup()

func setup():
	%ItemLabel.text = CraftingData.ItemType.keys()[crafting_data.item]
	var item_texture: CompressedTexture2D
	match crafting_data.item:
		CraftingData.ItemType.POTION_QUARTZ:
			item_texture = quartz_img
		CraftingData.ItemType.POTION_STONE:
			item_texture = stone_img
		CraftingData.ItemType.POTION_OIL:
			item_texture = oil_img
		CraftingData.ItemType.POTION_WOOD:
			item_texture = wood_img
		CraftingData.ItemType.ALLY_SPRITE:
			item_texture = ally_img
	%ItemTexture.texture = item_texture
			
	

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
	give_item()

func give_item():
	var tool_inv = GlobalVariables.get_toolbar().tool_inventory
	# Dont mind the below code it does the thing
	var proj_type: ThrownProjectile.Type
	var summon_type: EnemySpawner.EnemyType
	match crafting_data.item:
		CraftingData.ItemType.POTION_WOOD:
			proj_type = ThrownProjectile.Type.POTION_WOOD
		CraftingData.ItemType.POTION_STONE:
			proj_type = ThrownProjectile.Type.POTION_STONE
		CraftingData.ItemType.POTION_QUARTZ:
			proj_type = ThrownProjectile.Type.POTION_QUARTZ
		CraftingData.ItemType.POTION_OIL:
			proj_type = ThrownProjectile.Type.POTION_OIL
		CraftingData.ItemType.ALLY_SPRITE:
			summon_type = EnemySpawner.EnemyType.RockSprite
	if proj_type:
		tool_inv.set_potion_count(proj_type, tool_inv.get_potion_count(proj_type) + 1)
	elif summon_type:
		tool_inv.set_summon_count(summon_type, tool_inv.get_summon_count(summon_type) + 1)


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
