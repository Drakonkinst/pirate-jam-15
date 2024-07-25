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

const SCALE_MULTIPLIER := 0.05

@export var target: Vector2
@export var pickup_type: PickupType

@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]
@onready var sprite: Sprite2D = %Sprite2D

var pickup_value = 1
var collected = false

func set_sprite_scale():
    var screen_size = DisplayServer.screen_get_size()
    %Sprite2D.scale.x = SCALE_MULTIPLIER * screen_size.x / sprite.texture.get_width()
    %Sprite2D.scale.y = SCALE_MULTIPLIER * screen_size.x / sprite.texture.get_height()

func set_type(p_type: PickupType, texture: Texture2D):
    pickup_type = p_type
    sprite.texture = texture
    set_sprite_scale()
    choose_target()

func choose_target():
    # TODO: Should choose based on item type to go to the relevant resource tracker icon/label
    target = Vector2(200, 100)

func collect_resource():
    player.player_resources.add_count(pickup_type, pickup_value)

func cleanup():
    path_end.emit()
    collect_resource()
    queue_free()

func play_pickup_tween():
    var tween = create_tween()
    # tween.set_parallel(true)
    tween.tween_property(self, "position", target,2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    # tween.tween_property(%Sprite2D,"modulate",Color.RED,2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    tween.tween_callback(cleanup)

func _on_area_2d_mouse_entered():
    if collected:
        return
    collected = true
    play_pickup_tween()
