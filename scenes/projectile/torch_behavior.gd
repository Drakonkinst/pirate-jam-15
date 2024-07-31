extends ProjectileBehavior

class_name TorchBehavior

const ENEMY_TORCH_FIRE := 3.0

@export var light_anchor: Node2D

func on_ready(_projectile: ThrownProjectile):
    GlobalVariables.get_light_manager().spawn_tracking(light_anchor, GlobalVariables.TORCH_LIGHT_RADIUS, LightManager.Type.TORCH)

func on_land(pos: Vector2):
    var obstacle_manager: ObstacleManager = GlobalVariables.get_obstacle_manager()
    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(pos)

    var enemies_affected: Array[Enemy] = GlobalVariables.get_enemy_spawner().get_enemies_in_tile(tile)
    for enemy: Enemy in enemies_affected:
        if enemy.is_ally:
            continue
        enemy.set_on_fire(ENEMY_TORCH_FIRE)

    if tile == null:
        return

    var can_replace := true
    if tile.obstacle and not tile.obstacle.data.replaceable:
        can_replace = false
    if can_replace:
        obstacle_manager.replace_obstacle(Obstacle.Type.TORCH, tile)
    else:
        tile.obstacle.set_on_fire(GlobalVariables.TORCH_FIRE_DURATION)
        GlobalVariables.curr_game.score += 10
