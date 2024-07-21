extends Control

class_name ToolBarHud

const SELECT_1_INPUT = "select_1"
const SELECT_2_INPUT = "select_2"
const SELECT_3_INPUT = "select_3"
const SELECT_4_INPUT = "select_4"
const SELECT_5_INPUT = "select_5"

@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]
@export var toolbar: ToolBar

var is_tab_open: bool = false

func handle_click(mouse_pos: Vector2) -> bool:
    if is_tab_open:
        # TODO: Close tab
        is_tab_open = false
        return true

    return toolbar.handle_action(mouse_pos)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(SELECT_1_INPUT):
        toolbar.set_tool_slot(0)
    if event.is_action_pressed(SELECT_2_INPUT):
        toolbar.set_tool_slot(1)
    if event.is_action_pressed(SELECT_3_INPUT):
        toolbar.set_tool_slot(2)
    if event.is_action_pressed(SELECT_4_INPUT):
        toolbar.set_tool_slot(3)
    if event.is_action_pressed(SELECT_5_INPUT):
        toolbar.set_tool_slot(4)

func _on_attack_button_button_down() -> void:
    toolbar.set_tool(ToolBar.Tool.MAGIC_BOLT)

func _on_torch_button_button_down() -> void:
    toolbar.set_tool(ToolBar.Tool.TORCH)

func _on_destroy_button_button_down() -> void:
    toolbar.set_tool(ToolBar.Tool.PICKAXE)

func _on_potion_button_button_down() -> void:
    toolbar.set_tool(ToolBar.Tool.POTION)

func _on_summon_button_button_down() -> void:
    toolbar.set_tool(ToolBar.Tool.SUMMON)
