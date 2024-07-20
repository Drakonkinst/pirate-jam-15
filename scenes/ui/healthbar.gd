extends Control

class_name HealthBar

# https://youtu.be/YEZXVK1-tlU

const PERCENT_TO_DISPLAY := 100
const MIN_VALUE := 0
const MAX_VALUE := 100

@export var show_only_if_damaged: bool = true
@export var speed: float = 100
@export var delay_multiplier: float = 0.0085
@export var should_change_colors: bool = true
@export var healthy_color: Color
@export var caution_color: Color
@export var danger_color: Color
@export var caution_threshold: float = 0.5
@export var danger_threshold: float = 0.2

@onready var bar_over: TextureProgressBar = $BarOver
@onready var bar_under: TextureProgressBar = $BarUnder
var target_value: float
var is_changing: bool = false
var delay: float = 0

func _ready() -> void:
    set_percentage(1, true)

func _process(delta: float) -> void:
    if bar_under.value != target_value:
        if is_changing:
            delay = 0
            if bar_under.value < target_value:
                bar_under.value = min(target_value, bar_under.value + speed * delta)
            else:
                bar_under.value = max(target_value, bar_under.value - speed * delta)
        else:
            var amount = abs(bar_under.value - target_value)
            var wait_for = amount * delay_multiplier
            delay += delta
            if delay >= wait_for:
                is_changing = true
    elif is_changing:
        is_changing = false

# Jump the percentage without animating
func set_percentage(percent: float, instant: bool = false) -> void:
    target_value = percent * PERCENT_TO_DISPLAY
    bar_over.value = target_value
    if instant:
        bar_under.value = target_value
    if should_change_colors:
        update_color()
    if show_only_if_damaged:
        if target_value < MAX_VALUE:
            bar_over.show()
            bar_under.show()
        else:
            bar_over.hide()
            bar_under.hide()

func update_color() -> void:
    if target_value < MAX_VALUE * danger_threshold:
        bar_over.tint_progress = danger_color
    elif target_value < MAX_VALUE * caution_threshold:
        bar_over.tint_progress = caution_color
    else:
        bar_over.tint_progress = healthy_color

func _on_health_changed(_value: int, percent: float, instant: bool) -> void:
    set_percentage(percent, instant)
