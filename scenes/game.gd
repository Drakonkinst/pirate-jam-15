extends Node2D

class_name Game


func _input(event):
	if event.is_action_released("ui_cancel"):
		get_tree().quit()
