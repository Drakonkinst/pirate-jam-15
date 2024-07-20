extends Node

class_name ObstacleManager

# TODO: Spawn more types of objects
@export var tree_scene: PackedScene
@export var rock_scene: PackedScene
@export var oil_spill_scene: PackedScene
@export var torch_scene: PackedScene
@export var sapling_scene: PackedScene

func spawn_starting_obstacles(grid: Grid):
    # To demo obstacle spawning
    for tile: GridTile in GridIterator.new(grid):
        var obstacle_scene: PackedScene = null
        var choice = randi() % 7
        if choice == 0:
            obstacle_scene = tree_scene
        elif choice == 1:
            obstacle_scene = rock_scene
        elif choice == 2:
            obstacle_scene = oil_spill_scene
        elif choice == 3:
            obstacle_scene = sapling_scene

        if obstacle_scene:
            var obstacle_obj = obstacle_scene.instantiate()
            var obstacle = obstacle_obj as Obstacle
            tile.set_obstacle(obstacle)
