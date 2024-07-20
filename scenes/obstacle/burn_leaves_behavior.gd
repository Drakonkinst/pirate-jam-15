extends ObstacleBehavior

class_name BurnLeavesBehavior

const BURNT_LEAVES_AFTER: float = 4

@export var transform_into: Obstacle.Type

# Make trees/saplings transform into their dead variants (new obstacle types that do not grow) if they have burned long enough
func update(obstacle: Obstacle, _delta: float) -> void:
    if obstacle.transmuted_state != Obstacle.TransmutedState.DEFAULT:
        return

    if obstacle.burning_state.is_burning():
        if obstacle.burning_state.total_time_burned >= BURNT_LEAVES_AFTER:
            GlobalVariables.get_obstacle_manager().replace_obstacle(transform_into, obstacle.tile)