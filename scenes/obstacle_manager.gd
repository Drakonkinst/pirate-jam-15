extends Node2D

class_name ObstacleManager

@export var tree_scene: PackedScene
@export var rock_scene: PackedScene
@export var oil_spill_scene: PackedScene
@export var torch_scene: PackedScene
@export var sapling_scene: PackedScene
@export var dead_tree_scene: PackedScene
@export var dead_sapling_scene: PackedScene

@export var tree_spawn_audio: AudioRandomizer
@export var rock_spawn_audio: AudioRandomizer

func spawn_starting_obstacles(grid: Grid):
    # Just spawn 1 for testing
    # for tile: GridTile in GridIterator.new(grid):
    #     var obstacle = spawn_obstacle(Obstacle.Type.SAPLING, tile)
    #     obstacle.set_on_fire(5)
    #     break
    # return

    # To demo obstacle spawning
    for tile: GridTile in GridIterator.new(grid):
        var obstacle_scene: PackedScene = null
        var choice = randi() % 4
        if grid.should_ally_stop(tile) or grid.should_enemy_stop(tile):
            continue
        if choice == 0:
            obstacle_scene = tree_scene
        elif choice == 1:
            obstacle_scene = rock_scene

        if obstacle_scene:
            spawn_obstacle_scene(obstacle_scene, tile)

func get_scene_for_obstacle(type: Obstacle.Type) -> PackedScene:
    match type:
        Obstacle.Type.TREE:
            return tree_scene
        Obstacle.Type.DEAD_TREE:
            return dead_tree_scene
        Obstacle.Type.SAPLING:
            return sapling_scene
        Obstacle.Type.DEAD_SAPLING:
            return dead_sapling_scene
        Obstacle.Type.ROCK:
            return rock_scene
        Obstacle.Type.OIL_SPILL:
            return oil_spill_scene
        Obstacle.Type.TORCH:
            return torch_scene
        _:
            print("Unknown scene for obstacle ", Obstacle.Type.keys()[type])
            return null

func spawn_obstacle(obstacle: Obstacle.Type, tile: GridTile, make_sound: bool = false) -> Obstacle:
    var success = spawn_obstacle_scene(get_scene_for_obstacle(obstacle), tile)
    if success:
        if make_sound:
            if obstacle == Obstacle.Type.SAPLING:
                tree_spawn_audio.play_random()
            elif obstacle == Obstacle.Type.ROCK:
                rock_spawn_audio.play_random()
    return success

func replace_obstacle(new_obstacle: Obstacle.Type, tile: GridTile) -> Obstacle:
    return replace_obstacle_scene(get_scene_for_obstacle(new_obstacle), tile)

func spawn_obstacle_scene(obstacle_scene: PackedScene, tile: GridTile) -> Obstacle:
    if obstacle_scene == null:
        return
    var obstacle_obj = obstacle_scene.instantiate()
    var obstacle = obstacle_obj as Obstacle
    tile.set_obstacle(obstacle)
    return obstacle

func replace_obstacle_scene(new_obstacle_scene: PackedScene, tile: GridTile) -> Obstacle:
    if new_obstacle_scene == null:
        return
    var original_obstacle = tile.obstacle
    var new_obstacle = spawn_obstacle_scene(new_obstacle_scene, tile)

    if original_obstacle:
        print("TRANSFORM ", Obstacle.Type.keys()[original_obstacle.data.id], " -> ", Obstacle.Type.keys()[new_obstacle.data.id])
        # Keep health as percentage
        var health_percent = original_obstacle.health.get_percentage()
        new_obstacle.health.set_percentage(health_percent, true)
        # Keep burning state
        new_obstacle.copy_burning_state(original_obstacle.burning_state)
        # Keep model offset
        new_obstacle.model.set_offset(original_obstacle.model.offset)
    return new_obstacle

