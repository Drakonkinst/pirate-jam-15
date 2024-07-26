extends Node2D

class_name ToolBar

signal tool_changed(tool: Tool)
signal do_action(tool: Tool)

# Should be same order as in UI
enum Tool {
    MAGIC_BOLT, TORCH, PICKAXE, POTION, SUMMON
}

@onready var attack_cooldown: Timer = $AttackCooldown
@onready var destroy_cooldown: Timer = $DestroyCooldown
@onready var torch_cooldown: Timer = $TorchCooldown
@onready var potion_cooldown: Timer = $PotionCooldown
@onready var summon_cooldown: Timer = $SummonCooldown

@export var obstacle_damage: int = 10

# TODO: Inventory counts
var current_tool: Tool = Tool.MAGIC_BOLT
var selected_potion: ThrownProjectile.Type
var ordered_tool_cooldowns: Array[Timer]

func _ready() -> void:
    tool_changed.emit(current_tool)
    ordered_tool_cooldowns = [attack_cooldown, torch_cooldown, destroy_cooldown, potion_cooldown, summon_cooldown]

func handle_action(target_pos: Vector2) -> bool:
    # Do action based on current tool
    match current_tool:
        Tool.MAGIC_BOLT:
            if attack_cooldown.is_stopped():
                return _do_attack(target_pos)
        Tool.TORCH:
            if torch_cooldown.is_stopped():
                return _do_torch(target_pos)
        Tool.PICKAXE:
            if destroy_cooldown.is_stopped():
                return _do_destroy(target_pos)
        Tool.POTION:
            if potion_cooldown.is_stopped():
                return _do_potion(target_pos)
        Tool.SUMMON:
            if summon_cooldown.is_stopped():
                return _do_summon(target_pos)
        _:
            print("Unknown tool")
    return false

func _do_attack(target_pos: Vector2) -> bool:
    var projectile_manager: ProjectileManager = GlobalVariables.get_projectile_manager()
    var success = projectile_manager.fire_bolt(target_pos)
    if success:
        attack_cooldown.start()
        do_action.emit(ToolBar.Tool.MAGIC_BOLT)
    return success

func _do_torch(target_pos: Vector2) -> bool:
    var projectile_manager: ProjectileManager = GlobalVariables.get_projectile_manager()
    var success = projectile_manager.throw_projectile(ThrownProjectile.Type.TORCH, target_pos)
    if success:
        torch_cooldown.start()
        do_action.emit(ToolBar.Tool.TORCH)
    return success

# TODO: Should work when mouse button held as well
func _do_destroy(target_pos: Vector2) -> bool:
    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(target_pos)
    if tile == null:
        return false
    var obstacle: Obstacle = tile.obstacle
    if obstacle == null or obstacle.data.invulnerable:
        return false
    obstacle.damage(obstacle_damage)
    destroy_cooldown.start()
    do_action.emit(ToolBar.Tool.PICKAXE)
    return true

func _do_potion(target_pos: Vector2) -> bool:
    var projectile_manager: ProjectileManager = GlobalVariables.get_projectile_manager()
    # projectile_manager.throw_random_projectile(target_pos)
    var type: ThrownProjectile.Type

    var choice = randi() % 4
    if choice == 1:
        type = ThrownProjectile.Type.POTION_STONE
    elif choice == 2:
        type = ThrownProjectile.Type.POTION_QUARTZ
    elif choice == 3:
        type = ThrownProjectile.Type.POTION_OIL
    else:
        type = ThrownProjectile.Type.POTION_WOOD

    var success = projectile_manager.throw_projectile(type, target_pos)
    if success:
        potion_cooldown.start()
        do_action.emit(ToolBar.Tool.POTION)
    return success

func _do_summon(target_pos: Vector2) -> bool:
    summon_cooldown.start()
    var success = true
    if success:
        do_action.emit(ToolBar.Tool.SUMMON)
    return success

func set_tool(tool: Tool) -> void:
    current_tool = tool
    tool_changed.emit(current_tool)
    print("Set tool to ", Tool.keys()[tool])

func set_tool_slot(slot: int) -> void:
    set_tool(slot)

# Return an ordered list of cooldown percentages for each ability in the toolbar
func get_cooldown_array() -> Array[float]:
    var results: Array[float] = []
    for timer in ordered_tool_cooldowns:
        results.append(_get_cooldown_percentage(timer))
    return results

func _get_cooldown_percentage(timer: Timer) -> float:
    return timer.time_left / timer.wait_time


func _on_attack_cooldown_timer_timeout() -> void:
    attack_cooldown.stop()

func _on_destroy_cooldown_timer_timeout() -> void:
    destroy_cooldown.stop()

func _on_torch_cooldown_timer_timeout() -> void:
    torch_cooldown.stop()

func _on_potion_cooldown_timer_timeout() -> void:
    potion_cooldown.stop()

func _on_summon_cooldown_timer_timeout() -> void:
    summon_cooldown.stop()
