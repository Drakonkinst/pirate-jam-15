extends ObstacleBehavior

class_name TorchObstacleBehavior

@export var light_anchor: Node2D

func init(_obstacle: Obstacle) -> void:
    GlobalVariables.get_light_manager().spawn_tracking(light_anchor, GlobalVariables.TORCH_LIGHT_RADIUS, LightManager.Type.TORCH)
