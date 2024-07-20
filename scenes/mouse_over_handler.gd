extends Node2D

class_name MouseOverHandler

# Make sure to set mouse-over objects to match this!
@export_flags_2d_physics var mouse_over_mask

# https://forum.godotengine.org/t/is-it-possible-to-detect-if-a-mouse-pointer-is-hovering-over-area-2d/15073
# mouse_entered doesn't work consistently so I think this way is better
func _physics_process(_delta: float) -> void:
    var space = get_world_2d().direct_space_state
    var mouse_pos = get_viewport().get_mouse_position()
    var parameters: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
    parameters.position = mouse_pos
    parameters.collide_with_areas = true
    parameters.collide_with_bodies = false
    parameters.collision_mask = mouse_over_mask
    var hit: Array[Dictionary] = space.intersect_point(parameters, 10)
    if hit:
        for obj in hit:
            if obj.collider is MouseOverArea:
                var mouse_over_area = obj.collider as MouseOverArea
                mouse_over_area.moused_over.emit()
