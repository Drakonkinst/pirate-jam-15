extends Control

@onready var open_position = Vector2(0,self.position.y)
@onready var closed_position = Vector2(-300,self.position.y)
var can_interact = false
var focused = false

func _ready():
	position = closed_position
	
func on_click():
	print("CLICKED")
	

func toggle_interactible():
	can_interact = not can_interact
	if can_interact:
		mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

func move_panel_tween(pos):
	var open_tween = create_tween()
	open_tween.tween_property(self,"global_position",pos,1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	open_tween.play()
	open_tween.finished.connect(toggle_interactible)

func open_menu():
	if focused: 
		return
	print("Opening menu...")
	move_panel_tween(open_position)
	
func close_menu():
	if not focused:
		return
	print("Closing menu..")
	move_panel_tween(closed_position)



func _on_button_pressed():
	if focused:
		close_menu()
		focused = false
		%OpenButton.text = ">"
	else:
		open_menu()
		focused = true
		%OpenButton.text = "<"
