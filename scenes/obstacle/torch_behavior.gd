extends ObstacleBehavior

class_name TorchObstacleBehavior

const TORCH_MAX_AGE: float = 30.0

@export var fire_particle: Node2D

var age: float = 0.0
var expired: bool = false

func init(obstacle: Obstacle) -> void:
    obstacle.light_circle = GlobalVariables.get_light_manager().spawn_tracking(obstacle.light_anchor, GlobalVariables.TORCH_LIGHT_RADIUS, LightManager.Type.TORCH)

func update(obstacle: Obstacle, delta: float) -> void:
    if expired:
        return
    age += delta
    if age >= TORCH_MAX_AGE:
        # obstacle.kill() # Kill the obstacle by setting health to 0, which causes healthbar flicker
        # obstable.removed.emit() # Kill the obstacle immediately, better option

        # Experimental option:
        # Burn out the torch and light and keep the torch there
        fire_particle.hide()
        if obstacle.has_light():
            obstacle.delete_light()