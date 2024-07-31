extends CanvasLayer

class_name GameOverMenu

signal quit_to_menu
signal restart

@export var game_result_label: Label
@export var score_text: Label
@export var enemies_killed_text: Label
# TODO: Rounds survived or time survived

func enable() -> void:
	var sprites_killed = GlobalVariables.curr_game.sprites_killed
	var golems_killed = GlobalVariables.curr_game.golems_killed
	var game_result = GlobalVariables.curr_game.game_result
	game_result_label.text = game_result

	var enemies_killed = str(golems_killed + sprites_killed)
	enemies_killed_text.text = "Enemies Defeated: " + str(enemies_killed)

	var score = 10 * golems_killed + sprites_killed
	score_text.text = "Score: " + str(score)
	show()

func _on_quit_to_menu_button_pressed() -> void:
	quit_to_menu.emit()

func _on_restart_button_pressed() -> void:
	restart.emit()



