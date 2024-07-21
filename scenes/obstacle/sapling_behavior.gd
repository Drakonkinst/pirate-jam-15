extends ObstacleBehavior

class_name SaplingBehavior

const GROW_UP_AFTER: float = 20

var time_alive: float = 0
func update(obstacle: Obstacle, delta: float) -> void:
    if obstacle.transmuted_state != Obstacle.TransmutedState.DEFAULT:
        return
    time_alive += delta
    if time_alive >= GROW_UP_AFTER:
        GlobalVariables.get_obstacle_manager().replace_obstacle(Obstacle.Type.TREE, obstacle.tile)