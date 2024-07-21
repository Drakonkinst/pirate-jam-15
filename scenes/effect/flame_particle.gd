extends AnimatedSprite2D

class_name FlameParticle

const ANIMATION := "default"

func _ready() -> void:
    # Start on a random frame
    frame = randi() % sprite_frames.get_frame_count(ANIMATION)