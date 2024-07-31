extends Control

@export var day_cycle_manager: DayCycleManager
@export var skip_day_button: Button

@onready var progress_bar: ProgressBar = %ProgressBar

@onready var day_label: Label = %DayLabel

var day_time: float
var night_time: float

func _ready():
	day_cycle_manager.day_started.connect(change_day)
	day_cycle_manager.day_ended.connect(change_night)
	day_cycle_manager.interval_passed.connect(on_time_change)
	skip_day_button.hide()

func change_day():
	day_time = day_cycle_manager.day_length
	progress_bar.max_value = day_time
	progress_bar.value = 0
	day_label.text = "Daytime"
	skip_day_button.show()

func change_night():
	print("NIGHT BEGUN")
	night_time = day_cycle_manager.night_length
	progress_bar.max_value = night_time
	progress_bar.value = 0
	var night = day_cycle_manager.current_round
	day_label.text = "Night " + str(night + 1)
	skip_day_button.hide()

func on_time_change(curr_time: float):
	print("Current time is: " + str(curr_time))
	progress_bar.value = curr_time

func _on_day_cycle_manager_interval_passed(curr_time:float):
	on_time_change(curr_time)


func _on_day_cycle_manager_day_started(_round:int):
	change_day()

func _on_day_cycle_manager_day_ended(_round:int):
	change_night()

func _on_skip_day_button_pressed() -> void:
	day_cycle_manager.skip_day()
