extends Node

class_name ObstacleManager

# TODO: Spawn more types of objects
@export var obstacle_to_spawn: PackedScene

func spawn_starting_obstacles(grid: Grid):
    # To demo obstacle spawning
    for tile: GridTile in GridIterator.new(grid):
        if randf() < 0.3:
            var obstacle_obj = obstacle_to_spawn.instantiate()
            var obstacle = obstacle_obj as Obstacle
            tile.set_obstacle(obstacle)
