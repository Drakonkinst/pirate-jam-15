extends ObstacleBehavior

class_name TransformOnTransmuteBehavior

@export var transform_if_state: Obstacle.TransmutedState
@export var to_transform: Obstacle.Type

# This is not the best use of signals but hey it works
# The better way to do this would be to make a dedicated downstream function like update() but ah well
func _on_parent_transmuted(obstacle: Obstacle) -> void:
    if obstacle.transmuted_state == transform_if_state:
        obstacle.burning_state.is_burned = false
        GlobalVariables.get_obstacle_manager().replace_obstacle(to_transform, obstacle.tile)
