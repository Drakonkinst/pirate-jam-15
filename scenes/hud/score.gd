extends Label

class_name Score

const MIN_SPEED = 50
const ACCEL = 50
var display_score: float = 0.0
var target_score: float = 0.0
var speed := MIN_SPEED
func _process(delta: float) -> void:
    target_score = GlobalVariables.curr_game.score
    if display_score < target_score:
        display_score = min(display_score + speed * delta, target_score)
        speed += ACCEL
    elif display_score > target_score:
        display_score = max(display_score - speed * delta, target_score)
        speed += ACCEL
    else:
        speed = MIN_SPEED
    text = "Score: " + str(floor(display_score))
