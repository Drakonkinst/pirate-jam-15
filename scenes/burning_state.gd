extends Node2D

class_name BurningState

signal fire_tick
signal fire_expired
signal burnt

const TICK_INTERVAL: float = 1.0
const BURNED_AFTER: float = 2

# TODO: Small change for fire to spread? Do we want this mechanic?
var burning_time_remaining: float = 0
var total_time_burned: float = 0
var time_until_next_tick: float = 0
var is_burned: bool = false

func _process(delta: float) -> void:
    if is_burning():
        total_time_burned += delta
        time_until_next_tick -= delta
        if time_until_next_tick <= 0:
            fire_tick.emit()
            time_until_next_tick = TICK_INTERVAL
        if total_time_burned >= BURNED_AFTER and not is_burned:
            burnt.emit()
            is_burned = true
    var original_time = burning_time_remaining
    burning_time_remaining = max(0, burning_time_remaining - delta)
    if original_time > 0 and burning_time_remaining <= 0:
        fire_expired.emit()

func is_burning() -> bool:
    return burning_time_remaining > 0

func start_burning_time(duration: float) -> void:
    burning_time_remaining = max(burning_time_remaining, duration)

func reset_burning_time() -> void:
    burning_time_remaining = 0
