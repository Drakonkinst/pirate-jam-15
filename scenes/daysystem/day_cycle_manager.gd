extends Node2D

class_name DayCycleManager

signal day_started(curr_round: int) # Night End
signal day_ended(curr_round: int) # Night Start
signal interval_passed(curr_time: float) # Each second of the day/night
signal game_ended

@export var day_length: float
@export var night_length: float

@onready var is_night: bool
@onready var current_time: float = 0.0

var current_round = 0
const MAX_ROUNDS = 5

func _ready():
    start_day()

func _process(delta):
    current_time += delta
    if not is_night:
        if current_time > day_length:
            end_day()
    else:
        if current_time > night_length:
            if current_round > MAX_ROUNDS:
                game_ended.emit()
            else:
                start_day()
                current_round += 1

func get_current_time():
    return current_time

func start_day():
    %Interval.start()
    day_started.emit(current_round)
    current_time = 0.0
    is_night = false

func end_day():
    current_time = 0.0
    %Interval.stop()
    day_ended.emit(current_round)
    is_night = true

func _on_interval_timeout():
    interval_passed.emit(current_time)

func _on_enemies_wave_ended():
    start_day()