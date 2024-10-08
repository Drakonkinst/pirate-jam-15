extends Control

@export var day_cycle_manager: DayCycleManager
@export var skip_day_button: Button

@onready var progress_bar: ProgressBar = %ProgressBar

@onready var day_label: Label = %DayLabel

var day_time: float
var night_time: float

func _ready():
    skip_day_button.hide()

func change_day():
    day_time = day_cycle_manager.day_length
    progress_bar.max_value = day_time
    progress_bar.value = 0
    day_label.text = "Preparations"
    skip_day_button.show()

func change_night():
    print("NIGHT BEGUN")
    night_time = day_cycle_manager.night_length
    progress_bar.max_value = night_time
    progress_bar.value = 0
    var night = day_cycle_manager.current_round + 1
    if night == day_cycle_manager.MAX_ROUND:
        day_label.text = "Final Round"
    else:
        day_label.text = "Round " + str(night)
    skip_day_button.hide()

func on_time_change(curr_time: float):
    progress_bar.value = curr_time

func _on_day_cycle_manager_interval_passed(curr_time:float):
    on_time_change(curr_time)

func _on_day_cycle_manager_day_started(_round:int):
    change_day()

func _on_day_cycle_manager_day_ended(_round:int):
    change_night()

func _on_skip_day_button_pressed() -> void:
    day_cycle_manager.skip_day()
