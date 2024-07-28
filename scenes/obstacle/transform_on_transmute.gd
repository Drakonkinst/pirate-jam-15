extends ObstacleBehavior

class_name TransformOnTransmuteBehavior

@export var transform_if_state: Obstacle.TransmutedState
@export var to_transform: Obstacle.Type

func on_transmute(obstacle: Obstacle, to: Obstacle.TransmutedState) -> void:
    if to == transform_if_state:
        obstacle.burning_state.is_burned = false
        GlobalVariables.get_obstacle_manager().replace_obstacle(to_transform, obstacle.tile)
