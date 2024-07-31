extends Control

@onready var open_position = Vector2(-73,self.position.y)
@onready var closed_position = Vector2(-310,self.position.y)
@onready var potion_fill: PotionFill = %PotionFill
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
	open_tween.tween_property(self,"global_position",pos,0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
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
		%OpenButtonLabel.text = "CRAFT"
	else:
		open_menu()
		focused = true
		%OpenButtonLabel.text = "HIDE"

func _on_crafting_start(tint: Color) -> void:
	potion_fill.set_tint(tint)
	potion_fill.play()

func _on_ally_listing_4_crafting_start(tint: Color) -> void:
	_on_crafting_start(tint)

func _on_ally_listing_3_crafting_start(tint: Color) -> void:
	_on_crafting_start(tint)

func _on_ally_listing_crafting_start(tint: Color) -> void:
	_on_crafting_start(tint)

func _on_wood_listing_crafting_start(tint: Color) -> void:
	_on_crafting_start(tint)

func _on_stone_listing_crafting_start(tint: Color) -> void:
	_on_crafting_start(tint)

func _on_quartz_listing_crafting_start(tint: Color) -> void:
	_on_crafting_start(tint)

func _on_oil_listing_crafting_start(tint: Color) -> void:
	_on_crafting_start(tint)

func _on_ally_listing_2_crafting_start(tint: Color) -> void:
	_on_crafting_start(tint)
