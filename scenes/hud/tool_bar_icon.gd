extends TextureButton

class_name ToolBarIcon

const MAX_PROGRESS_VALUE := 100
const MIN_PROGRESS_OPACITY := 0.5
const MAX_PROGRESS_OPACITY := 0.8

@onready var progress_overlay: TextureProgressBar = $ProgressOverlay

func apply_material(m: Material) -> void:
    material = m

func update_cooldown(percent: float) -> void:
    percent = 1 - percent
    progress_overlay.value = percent * MAX_PROGRESS_VALUE
    if progress_overlay.value >= MAX_PROGRESS_VALUE:
        progress_overlay.modulate.a = 1
    else:
        progress_overlay.modulate.a = MIN_PROGRESS_OPACITY + (MAX_PROGRESS_OPACITY - MIN_PROGRESS_OPACITY) * percent
