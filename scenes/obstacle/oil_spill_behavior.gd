extends ObstacleBehavior

class_name OilSpillBehavior

const MAX_BURNING_TIME: float = 999999
const BURNS_OUT_AFTER: float = 10

func update(obstacle: Obstacle) -> void:
    if obstacle.burning_state.is_burning():
        obstacle.set_on_fire(MAX_BURNING_TIME)
        if obstacle.burning_state.total_time_burned >= BURNS_OUT_AFTER:
            obstacle.kill()
