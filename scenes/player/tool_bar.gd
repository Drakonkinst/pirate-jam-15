extends Node2D

class_name ToolBar

# Should be same order as in UI
enum Tool {
    MAGIC_BOLT, TORCH, PICKAXE, POTION, SUMMON
}

@onready var attack_cooldown: Timer = $AttackCooldown
@onready var destroy_cooldown: Timer = $DestroyCooldown
@onready var torch_cooldown: Timer = $TorchCooldown
@onready var potion_cooldown: Timer = $PotionCooldown
@onready var summon_cooldown: Timer = $SummonCooldown

# TODO: Inventory counts
var current_tool: Tool = Tool.MAGIC_BOLT
var selected_potion: ThrownProjectile.Type

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
    attack_cooldown.start()
    return true

func _do_torch(target_pos: Vector2) -> bool:
    var projectile_manager: ProjectileManager = GlobalVariables.get_projectile_manager()
    projectile_manager.throw_projectile(ThrownProjectile.Type.TORCH, target_pos)
    torch_cooldown.start()
    return true

# TODO: Should work when mouse button held as well
func _do_destroy(target_pos: Vector2) -> bool:
    destroy_cooldown.start()
    return true

func _do_potion(target_pos: Vector2) -> bool:
    var projectile_manager: ProjectileManager = GlobalVariables.get_projectile_manager()
    projectile_manager.throw_projectile(ThrownProjectile.Type.POTION_OIL, target_pos)
    potion_cooldown.start()
    return true

func _do_summon(target_pos: Vector2) -> bool:
    summon_cooldown.start()
    return true

func set_tool(tool: Tool) -> void:
    current_tool = tool
    print("Set tool to ", Tool.keys()[tool])

func set_tool_slot(slot: int) -> void:
    set_tool(slot)

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
