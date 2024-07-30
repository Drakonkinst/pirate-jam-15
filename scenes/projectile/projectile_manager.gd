extends Node2D

class_name ProjectileManager

const CLICK_INPUT := "click"
const GRAVITY: float = 1000.0
const INVERT_Y: Vector2 = Vector2(1.0, -1.0)

@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]

@export var magic_bolt_scene: PackedScene
@export var torch_scene: PackedScene
@export var potion_oil_scene: PackedScene
@export var potion_wood_scene: PackedScene
@export var potion_stone_scene: PackedScene
@export var potion_quartz_scene: PackedScene
@export var thrown_pickaxe_scene: PackedScene
@export var thrown_enemy_scene: PackedScene
@export var debug_marker_scene: PackedScene
@export var explosion_scene: PackedScene
@export var splat_scene: PackedScene
@export var explosion_parent: Node2D
@export var splat_parent: Node2D
@export var show_debug: bool = false
@export var throw_offset: Vector2
@export var fire_offset: Vector2
@export var arc_height_multiplier: float = 0.25
@onready var splash_audio: AudioRandomizer = %SplashAudio
@onready var pickaxe_audio: AudioRandomizer = %PickaxeAudio
@onready var summon_audio: AudioRandomizer = %SummonAudio

func _get_scene_for_projectile(type: ThrownProjectile.Type) -> PackedScene:
    match type:
        ThrownProjectile.Type.POTION_QUARTZ:
            return potion_quartz_scene
        ThrownProjectile.Type.POTION_STONE:
            return potion_stone_scene
        ThrownProjectile.Type.POTION_WOOD:
            return potion_wood_scene
        ThrownProjectile.Type.POTION_OIL:
            return potion_oil_scene
        ThrownProjectile.Type.TORCH:
            return torch_scene
        ThrownProjectile.Type.PICKAXE:
            return thrown_pickaxe_scene
        ThrownProjectile.Type.ENEMY:
            return thrown_enemy_scene
        _:
            print("Unknown scene for projectile ", ThrownProjectile.Type.keys()[type])
            return null

func fire_projectile(projectile: ThrownProjectile.Type, from: Vector2, to: Vector2) -> ThrownProjectile:
    return _fire_projectile_scene(_get_scene_for_projectile(projectile), from, to)

func _fire_projectile_scene(projectile_scene: PackedScene, from: Vector2, to: Vector2) -> ThrownProjectile:
    var projectile_obj = projectile_scene.instantiate()
    add_child(projectile_obj)
    var projectile = projectile_obj as ThrownProjectile
    projectile.global_position = from
    projectile.target_y = to.y
    projectile.gravity = GRAVITY
    projectile.velocity = _calculate_trajectory(from, to)
    return projectile

func place_explosion(pos: Vector2) -> Explosion:
    var explosion_obj = explosion_scene.instantiate()
    explosion_obj.position = pos
    explosion_parent.add_child(explosion_obj)
    var explosion = explosion_obj as Explosion
    splash_audio.play_random()
    return explosion

func place_splat(pos: Vector2) -> Splat:
    var splat_obj = splat_scene.instantiate()
    splat_obj.position = pos
    splat_obj.z_index = -1 # Appear below obstacles on the grid
    splat_parent.add_child(splat_obj)
    var splat = splat_obj as Splat
    return splat

func play_pickaxe_audio() -> void:
    pickaxe_audio.play_random()

func play_summon_audio() -> void:
    summon_audio.play_random()

func throw_projectile(projectile: ThrownProjectile.Type, mouse_pos: Vector2) -> bool:
    if not is_valid_target(mouse_pos, true):
        return false
    fire_projectile(projectile, player.global_position + throw_offset, mouse_pos)
    return true

func is_valid_target(pos: Vector2, is_throwing: bool) -> bool:
    var grid: Grid = GlobalVariables.get_grid()
    # Cannot throw behind
    if pos.x <= grid.find_grid_origin().x:
        return false
    if is_throwing and not grid.is_on_grid(pos):
        return false
    return true

# For debug
# Random bullshit, go!
func throw_random_projectile(to: Vector2) -> bool:
    return throw_projectile(randi() % ThrownProjectile.Type.keys().size(), to)

func fire_bolt(to: Vector2) -> bool:
    if not is_valid_target(to, false):
        return false
    var bolt_obj = magic_bolt_scene.instantiate()
    add_child(bolt_obj)
    var bolt = bolt_obj as MagicBolt
    bolt.init(player.global_position + fire_offset, to)
    return true

func _place_debug_circle(pos: Vector2):
    if not show_debug:
        return
    var obj = debug_marker_scene.instantiate()
    add_child(obj)
    obj.position = pos

# https://gamedev.stackexchange.com/questions/114635
func _calculate_trajectory(from: Vector2, to: Vector2) -> Vector2:
    # Act as if starting from the origin
    var end = (to - from)
    # Flip y since +y is down
    end.y = -end.y
    _place_debug_circle(end * INVERT_Y + from)

    # Select a point above the player to make a nice arc
    var midpoint: Vector2 = Vector2(end.x / 2, max(end.y, arc_height_multiplier * end.x))
    _place_debug_circle(midpoint * INVERT_Y + from)

    # Find time to reach end in a parabola that passes through all three points
    var time_to_reach_target = sqrt(2 * (end.y - midpoint.y * end.x / midpoint.x) / (-GRAVITY * (1 - midpoint.x/end.x)))

    # Find velocity required to reach end in that time
    var velocity = end / time_to_reach_target - time_to_reach_target * Vector2(0, -GRAVITY / 2)

    # Flip y since +y is pointing down
    velocity.y = -velocity.y
    return velocity

