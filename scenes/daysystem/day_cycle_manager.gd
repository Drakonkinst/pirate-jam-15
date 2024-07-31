extends Node2D

class_name DayCycleManager

signal day_started(curr_round: int) # Night End
signal day_ended(curr_round: int) # Night Start
signal interval_passed(curr_time: float) # Each second of the day/night
signal game_over

@export var day_length: float
@export var night_length: float

@export var dialogue: Array[Conversation]

@onready var is_night: bool
@onready var current_time: float = 0.0

var current_round = 0
const MAX_ROUND = 5

func _process(delta):
    current_time += delta
    if not is_night:
        if current_time > day_length:
            end_day()
    

func skip_day() -> void:
    end_day()

func get_current_time():
    return current_time

func start_day():
    if current_round >= MAX_ROUND:
        GlobalVariables.curr_game.game_result = "You won!"
        game_over.emit()
    %Interval.start()
    day_started.emit(current_round)
    current_time = 0.0
    is_night = false
    GlobalVariables.get_dialogue_manager().play_conversation(dialogue[current_round])

func end_day():
    current_time = 0.0
    %Interval.stop()
    day_ended.emit(current_round)
    is_night = true

func _on_interval_timeout():
    interval_passed.emit(current_time)

func _on_enemies_wave_ended():
    current_round += 1
    start_day()
