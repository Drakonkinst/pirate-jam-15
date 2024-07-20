extends ObstacleBehavior

class_name SaplingBehavior

const GROW_UP_AFTER: float = 20

var time_alive: float = 0
func update(obstacle: Obstacle, delta: float) -> void:
    time_alive += delta
    if time_alive >= GROW_UP_AFTER:
        # TODO: Replace with a living tree
        pass