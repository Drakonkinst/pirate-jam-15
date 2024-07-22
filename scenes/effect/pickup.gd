extends Node2D 

class_name Pickup

signal path_end


enum PickupType {
    GOLD,
    FIRE,
    QUARTZ,
    SAP,
    FRUIT,
}

var PICKUP_TEXTURES = {
    GOLD = load("res://assets/textures/tile_coin.png"),
    FIRE = load("res://assets/textures/fire_5.png"),
    QUARTZ = load("res://assets/textures/quartz_rock.png"),
    SAP = load("res://assets/textures/potion.png"),
    FRUIT = load("res://assets/textures/potion_wood.png"),
}

@export var target: Vector2
@export var pickup_type: PickupType
var collected = false
@onready var sprite = %Sprite2D
var pickup_value = 1


func set_sprite_scale():
    var screen_size = DisplayServer.screen_get_size()
    %Sprite2D.scale.x = 0.05 * screen_size.x / %Sprite2D.texture.get_width()
    %Sprite2D.scale.y = 0.05 * screen_size.x / %Sprite2D.texture.get_height()

func set_type(p_type: PickupType):
    pickup_type = p_type
    apply_texture()
    set_sprite_scale()
    choose_target()

func choose_target():
    target = Vector2(0,500)

func collect_resource():
    var player_resources = GlobalVariables.player_resources
    match pickup_type:
        PickupType.GOLD:
            player_resources.gold += pickup_value
        PickupType.FIRE:
            player_resources.fire_crystals += pickup_value
        PickupType.QUARTZ:
            player_resources.quartz += pickup_value
        PickupType.SAP:
            player_resources.amber_sap += pickup_value
        PickupType.FRUIT:
            player_resources.fruit += pickup_value
    

func apply_texture():
    var pickup_texture: Texture2D = PICKUP_TEXTURES.values()[pickup_type]
    %Sprite2D.texture = pickup_texture

func cleanup():
    path_end.emit()
    collect_resource()
    queue_free()

func play_pickup_tween():
    var tween = create_tween()
    tween.tween_property(self,"position", target,2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    tween.tween_callback(cleanup)

func _on_area_2d_mouse_entered():
    if collected: 
        return
    collected = true
    play_pickup_tween()
