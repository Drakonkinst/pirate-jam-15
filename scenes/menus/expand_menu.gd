extends Control

class_name ExpandMenu

signal click_index(index: int)
signal menu_opened
signal menu_closed

@export var option_1_texture: Texture2D
@export var option_2_texture: Texture2D
@export var option_3_texture: Texture2D
@export var option_4_texture: Texture2D

@onready var expand_button: Control = $ExpandButton
@onready var dropdown: Control = $Dropdown

@onready var button_1: TextureButton = %Button1
@onready var button_2: TextureButton = %Button2
@onready var button_3: TextureButton = %Button3
@onready var button_4: TextureButton = %Button4

@onready var count_1: Label = %Count1
@onready var count_2: Label = %Count2
@onready var count_3: Label = %Count3
@onready var count_4: Label = %Count4

func _ready() -> void:
    hide_dropdown()
    button_1.texture_normal = option_1_texture
    button_2.texture_normal = option_2_texture
    button_3.texture_normal = option_3_texture
    button_4.texture_normal = option_4_texture

func update_counts(counts: Array[int]) -> void:
    count_1.text = str(counts[0])
    count_2.text = str(counts[1])
    count_3.text = str(counts[2])
    count_4.text = str(counts[3])

func hide_dropdown() -> void:
    expand_button.show()
    dropdown.hide()

func show_dropdown() -> void:
    expand_button.hide()
    dropdown.show()

func _on_hide_button_pressed() -> void:
    hide_dropdown()
    menu_closed.emit()

func _on_expand_button_pressed() -> void:
    show_dropdown()
    menu_opened.emit()

func _press_option(index: int) -> void:
    hide_dropdown()
    menu_closed.emit()
    click_index.emit(index)

func _on_button_1_pressed() -> void:
    _press_option(0)

func _on_button_2_pressed() -> void:
    _press_option(1)

func _on_button_3_pressed() -> void:
    _press_option(2)

func _on_button_4_pressed() -> void:
    _press_option(3)
