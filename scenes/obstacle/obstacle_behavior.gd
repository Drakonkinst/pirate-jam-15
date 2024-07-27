extends Node2D

class_name ObstacleBehavior

# Can be overridden
func update(_obstacle: Obstacle, _delta: float) -> void:
    pass

# Can be overridden
func init(_obstacle: Obstacle) -> void:
    pass

# Can be overridden
func on_transmute(_obstacle: Obstacle, _to: Obstacle.TransmutedState) -> void:
    pass
