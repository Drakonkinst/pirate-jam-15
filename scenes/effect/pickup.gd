extends Node2D

class_name Pickup

signal path_end

enum PickupType {
    GOLD,
    FIRE,
    QUARTZ,
    SAP,
    FRUIT,
    STONE
}

const SCALE_MULTIPLIER := 0.1
const TWEEN_TIME := 1

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

func init(p_type: PickupType, texture: Texture2D, target_pos: Vector2, pos: Vector2):
    pickup_type = p_type
    sprite.texture = texture
    target = target_pos
    global_position = pos
    set_sprite_scale()

func collect_resource():
    player.player_resources.add_count(pickup_type, pickup_value)

func cleanup():
    path_end.emit()
    collect_resource()
    queue_free()

func play_pickup_tween():
    var tween = create_tween()
    # tween.set_parallel(true)
    tween.tween_property(self, "position", target, TWEEN_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
    # tween.tween_property(%Sprite2D,"modulate",Color.RED,2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    tween.tween_callback(cleanup)

func _on_area_2d_mouse_entered():
    if collected:
        return
    collected = true
    play_pickup_tween()
