extends Sprite2D

class_name LightCircle

signal removed

var tracking: Node2D
var light_radius: float
var light_type: LightManager.Type

@onready var light_glow: LightGlow = $LightGlow

func init(track_node: Node2D, radius: float, type: LightManager.Type) -> void:
    var texture_width = texture.get_width()
    var texture_height = texture.get_height()
    tracking = track_node
    scale = Vector2(radius / texture_width, radius / texture_height)
    light_radius = radius
    light_type = type
    light_glow.original_scale = scale

func is_in_circle(pos: Vector2) -> bool:
	var delta_x = abs(pos.x - global_position.x)
	var delta_y = abs(pos.y - global_position.y)
	var dist_sq = delta_x * delta_x + delta_y * delta_y
	return dist_sq <= light_radius * light_radius

func _process(_delta: float) -> void:
	if is_instance_valid(tracking) and tracking != null and not tracking.is_queued_for_deletion():
		global_position = tracking.global_position
	else:
		removed.emit()
		queue_free()
