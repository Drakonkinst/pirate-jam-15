extends ProjectileBehavior

class_name PickaxeBehavior

@export var obstacle_damage: int = 20
@export var enemy_damage: int = 40

func on_land(pos: Vector2):
    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(pos)

    var enemies_affected: Array[Enemy] = GlobalVariables.get_enemy_spawner().get_enemies_in_tile(tile)
    var success := false
    for enemy: Enemy in enemies_affected:
        if enemy.is_ally:
            continue
        var dmg = enemy_damage
        if enemy.enemy_data.type == EnemySpawner.EnemyType.RockGolem:
            dmg *= 8
        if enemy.enemy_data.type == EnemySpawner.EnemyType.RockSprite:
            dmg *= 2
        enemy.damage(dmg)
        success = true

    if tile == null:
        return

    if tile.obstacle and not tile.obstacle.data.invulnerable:
        success = true
        tile.obstacle.damage(obstacle_damage)
    if success:
        GlobalVariables.get_projectile_manager().play_pickaxe_audio()


