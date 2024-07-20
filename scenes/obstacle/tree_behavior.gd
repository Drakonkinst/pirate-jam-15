extends ObstacleBehavior

class_name TreeBehavior

const BURNT_LEAVES_AFTER: float = 3

func update(obstacle: Obstacle, _delta: float) -> void:
    # TODO: Grow fruit
    if obstacle.burning_state.is_burning():
        if obstacle.burning_state.total_time_burned >= BURNT_LEAVES_AFTER:
            # TODO: Replace with a dead tree
            pass