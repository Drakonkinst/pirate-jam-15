extends ProjectileBehavior

class_name ThrownEnemyBehavior

@export var sprite: Sprite2D
@export var stone_texture: Texture2D
@export var wood_texture: Texture2D
@export var wind_texture: Texture2D
@export var fire_texture: Texture2D

var enemy_to_spawn: EnemySpawner.EnemyType

func on_ready(projectile: ThrownProjectile):
    enemy_to_spawn = projectile.enemy_to_spawn
    if enemy_to_spawn == EnemySpawner.EnemyType.WindSprite:
        sprite.texture = wind_texture
    if enemy_to_spawn == EnemySpawner.EnemyType.FireSprite:
        sprite.texture = fire_texture
    if enemy_to_spawn == EnemySpawner.EnemyType.RockSprite:
        sprite.texture = stone_texture
    if enemy_to_spawn == EnemySpawner.EnemyType.TreeSprite:
        sprite.texture = wood_texture

func on_land(pos: Vector2):
    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(pos)

    if tile == null:
        return

    GlobalVariables.get_enemy_spawner().summon_ally_at_tile(enemy_to_spawn, tile, pos.y)
    GlobalVariables.get_projectile_manager().play_summon_audio()

