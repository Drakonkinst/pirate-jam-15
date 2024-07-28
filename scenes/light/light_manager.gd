extends CanvasGroup

class_name LightManager

enum Type {
    TORCH, QUARTZ, FIRE
}

@export var light_circle_scene: PackedScene

func spawn_tracking(track_node: Node2D, radius: float, type: Type) -> void:
    var light_obj = light_circle_scene.instantiate()
    add_child(light_obj)
    var light = light_obj as LightCircle
    light.init(track_node, radius, type)

func _process(_delta: float) -> void:
    pass

func is_in_light(pos: Vector2) -> bool:
    for light in get_children():
        if light.is_in_circle(pos):
            return true
    return false
