extends ObstacleBehavior

class_name OilSpillBehavior

const MAX_BURNING_TIME: float = 999999
const BURNS_OUT_AFTER: float = 10

const MAX_SCALE = 1.0
const MIN_SCALE = 0.65

@export var model: ObstacleModel

func update(obstacle: Obstacle, _delta: float) -> void:
    if obstacle.burning_state.is_burning():
        obstacle.set_on_fire(MAX_BURNING_TIME)
        if obstacle.burning_state.total_time_burned >= BURNS_OUT_AFTER:
            obstacle.kill()
    var new_scale = MAX_SCALE - (MAX_SCALE - MIN_SCALE) * (obstacle.burning_state.total_time_burned / BURNS_OUT_AFTER)
    model.scale = Vector2(new_scale, new_scale)
