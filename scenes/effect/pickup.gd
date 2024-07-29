extends Node2D

class_name Pickup

signal path_end

enum PickupType {
    SHADOWSAND,
    FIRE,
    QUARTZ,
    SAP,
    FRUIT,
    STONE
}

const SCALE_MULTIPLIER := 0.1
const TWEEN_TIME := 1.5

const FLOAT_MIN_TIME := 1
const FLOAT_MAX_TIME := 1.2
const FLOAT_MIN_ANGLE := 240.0
const FLOAT_MAX_ANGLE := 300.0
const FLOAT_SPEED := 300.0
const GRAVITY := 450.0

const BOBBING_SPEED := 3.0
const BOBBING_AMPLITUDE := 7.0

@export var target: Vector2
@export var pickup_type: PickupType

@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]
@onready var pickup_audio: AudioRandomizer = %PickupAudio
@onready var sprite: Sprite2D = %Sprite2D

var pickup_value: int = 1
var collected: bool = false

var float_time_remaining: float
var floating: bool
var velocity: Vector2

var landing_age: float = 0
var landing_position: Vector2

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
    start_floating()

func _physics_process(delta: float) -> void:
    # If collected, ignore all other movement
    if collected:
        return

    # If just generated, float a ways
    if float_time_remaining > 0:
        position += velocity * delta
        velocity += Vector2(0, GRAVITY) * delta
        float_time_remaining -= delta
    elif floating:
        floating = false
        landing_age = 0
        landing_position = position


    # If landed, start bobbing in place
    if not floating:
        var offset = sin(landing_age * BOBBING_SPEED)
        position = landing_position + Vector2(0, -offset * BOBBING_AMPLITUDE)
        landing_age += delta

func start_floating() -> void:
    float_time_remaining = randf_range(FLOAT_MIN_TIME, FLOAT_MAX_TIME)
    floating = true
    var angle = deg_to_rad(randf_range(FLOAT_MIN_ANGLE, FLOAT_MAX_ANGLE))
    var dir: Vector2 = Vector2(cos(angle), sin(angle))
    velocity = dir * FLOAT_SPEED

func collect_resource():
    player.player_resources.add_count(pickup_type, pickup_value)

func cleanup():
    path_end.emit()
    collect_resource()
    queue_free()

func play_pickup_tween():
    var tween = create_tween()
    # tween.set_parallel(true)
    tween.tween_property(self, "position", target, TWEEN_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    # tween.tween_property(%Sprite2D,"modulate",Color.RED,2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    tween.tween_callback(cleanup)

func _on_area_2d_mouse_entered():
    if collected or floating:
        return
    collected = true
    pickup_audio.play_random()
    play_pickup_tween()
