extends Resource

class_name CraftingData

enum ItemType {
	#Potions
	POTION_QUARTZ,
	POTION_FIRE,
	POTION_OIL,
	POTION_WOOD,
	#Allies
	ALLY_SPRITE,
}

@export var item: ItemType
@export var recipe_list: Array[RecipeListing]
@export var crafting_time: float = 1.0

