extends Control

class_name ToolBarHud

const SELECT_1_INPUT = "select_1"
const SELECT_2_INPUT = "select_2"
const SELECT_3_INPUT = "select_3"
const SELECT_4_INPUT = "select_4"
const SELECT_5_INPUT = "select_5"
const HOTBAR_NEXT = "hotbar_next"
const HOTBAR_PREV = "hotbar_prev"

const TOOL_ORDER: Array[ToolBar.Tool] = [
    ToolBar.Tool.MAGIC_BOLT,
    ToolBar.Tool.TORCH,
    ToolBar.Tool.PICKAXE,
    ToolBar.Tool.POTION,
    ToolBar.Tool.SUMMON
]
const POTION_ORDER: Array[ThrownProjectile.Type] = [
    ThrownProjectile.Type.POTION_WOOD,
    ThrownProjectile.Type.POTION_STONE,
    ThrownProjectile.Type.POTION_QUARTZ,
    ThrownProjectile.Type.POTION_OIL,
]
const SUMMON_ORDER: Array[EnemySpawner.EnemyType] = [
    EnemySpawner.EnemyType.TreeSprite,
    EnemySpawner.EnemyType.RockSprite,
    EnemySpawner.EnemyType.WindSprite,
    EnemySpawner.EnemyType.FireSprite
]
@export var buttons: Array[ToolBarIcon]
@export var highlight_material: Material
@export var highlight_thin_material: Material
@export var highlight_thick_material: Material
@export var potion_expand_menu: ExpandMenu
@export var summon_expand_menu: ExpandMenu
@export var potion_tool_icons: Array[Texture2D]
@export var summon_tool_icons: Array[Texture2D]
@export var current_potion_count: Label
@export var current_summon_count: Label

@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]
var toolbar: ToolBar

var is_tab_open: bool = false
var started_first_click: bool = false
var current_tool_index: int = 0

func _ready() -> void:
    toolbar = GlobalVariables.get_toolbar()
    _set_selected_potion(0)
    _set_selected_summon(0)

func _process(_delta: float) -> void:
    var cooldown_array: Array[float] = toolbar.get_cooldown_array()
    for i in buttons.size():
        buttons[i].update_cooldown(cooldown_array[i])

# Really it should be ToolBar handling input and not the UI component, but ah well
func handle_click(mouse_pos: Vector2, first_click: bool) -> bool:
    if is_tab_open:
        potion_expand_menu.hide_dropdown()
        summon_expand_menu.hide_dropdown()
        is_tab_open = false
        return true

    if first_click:
        started_first_click = true
    if started_first_click:
        return toolbar.handle_action(mouse_pos)
    return false

func off_click() -> void:
    started_first_click = false

func _set_selected_potion(index: int) -> void:
    toolbar.set_selected_potion(POTION_ORDER[index])
    var tool_index: int = TOOL_ORDER.find(ToolBar.Tool.POTION)
    var new_texture: Texture2D = potion_tool_icons[index]
    # buttons[tool_index].texture_normal = new_texture
    buttons[tool_index].progress_overlay.texture_progress = new_texture

func _set_selected_summon(index: int) -> void:
    toolbar.set_selected_summon(SUMMON_ORDER[index])
    var tool_index: int = TOOL_ORDER.find(ToolBar.Tool.SUMMON)
    var new_texture: Texture2D = summon_tool_icons[index]
    # buttons[tool_index].texture_normal = new_texture
    buttons[tool_index].progress_overlay.texture_progress = new_texture

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
    if event.is_action_pressed(HOTBAR_NEXT):
        var next_slot = (current_tool_index + 1) % TOOL_ORDER.size()
        toolbar.set_tool_slot(next_slot)
    elif event.is_action_pressed(HOTBAR_PREV):
        var prev_slot = (current_tool_index + TOOL_ORDER.size() - 1) % TOOL_ORDER.size()
        toolbar.set_tool_slot(prev_slot)

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

func _on_tool_bar_tool_changed(tool: ToolBar.Tool) -> void:
    var tool_index = TOOL_ORDER.find(tool, 0)
    var needs_thin = tool == ToolBar.Tool.POTION
    var needs_thick = tool == ToolBar.Tool.SUMMON
    for i in buttons.size():
        if i == tool_index:
            if needs_thick:
                buttons[i].apply_material(highlight_thick_material)
            if needs_thin:
                buttons[i].apply_material(highlight_thin_material)
            else:
                buttons[i].apply_material(highlight_material)
        else:
            buttons[i].apply_material(null)
    current_tool_index = tool_index

func _on_potion_expand_menu_click_index(index: int) -> void:
    toolbar.set_tool(ToolBar.Tool.POTION)
    _set_selected_potion(index)

func _on_summon_expand_menu_click_index(index: int) -> void:
    toolbar.set_tool(ToolBar.Tool.SUMMON)
    _set_selected_summon(index)

func _on_potion_expand_menu_menu_opened() -> void:
    summon_expand_menu.hide_dropdown()
    is_tab_open = true

func _on_summon_expand_menu_menu_opened() -> void:
    potion_expand_menu.hide_dropdown()
    is_tab_open = true

func _on_potion_expand_menu_menu_closed() -> void:
    is_tab_open = false

func _on_summon_expand_menu_menu_closed() -> void:
    is_tab_open = false

func _on_tool_bar_tool_inventory_updated() -> void:
    # Update cooldown counts
    potion_expand_menu.update_counts(toolbar.tool_inventory.get_potion_counts())
    summon_expand_menu.update_counts(toolbar.tool_inventory.get_summon_counts())
    var potion_count = toolbar.tool_inventory.get_potion_count(toolbar.selected_potion)
    current_potion_count.text = str(potion_count)
    var summon_count = toolbar.tool_inventory.get_summon_count(toolbar.selected_summon)
    current_summon_count.text = str(summon_count)
