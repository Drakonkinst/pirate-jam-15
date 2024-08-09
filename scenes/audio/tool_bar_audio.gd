extends Node2D

class_name ToolBarAudio

@onready var do_attack: AudioRandomizer = %DoAttackAudio
@onready var do_torch: AudioRandomizer = %DoTorchAudio
@onready var do_pickaxe: AudioRandomizer = %DoPickaxeAudio
@onready var do_potion: AudioRandomizer = %DoPotionAudio
@onready var do_summon: AudioRandomizer = %DoSummonAudio

@onready var equip_attack: AudioRandomizer = %EquipAttackAudio
@onready var equip_torch: AudioRandomizer = %EquipTorchAudio
@onready var equip_pickaxe: AudioRandomizer = %EquipPickaxeAudio
@onready var equip_potion: AudioRandomizer = %EquipPotionAudio
@onready var equip_summon: AudioRandomizer = %EquipSummonAudio

# TODO: Move this to be outside ToolBar

# MAGIC_BOLT, TORCH, PICKAXE, POTION, SUMMON

# Ignore the first tool change on game start
var curr_tool: ToolBar.Tool = ToolBar.Tool.MAGIC_BOLT

func on_tool_changed(tool_type: ToolBar.Tool) -> void:
    var has_changed = tool_type != curr_tool
    curr_tool = tool_type
    if not has_changed:
        return

    match tool_type:
        ToolBar.Tool.MAGIC_BOLT:
            equip_attack.play_random()
        ToolBar.Tool.TORCH:
            equip_torch.play_random()
        ToolBar.Tool.PICKAXE:
            equip_pickaxe.play_random()
        ToolBar.Tool.POTION:
            equip_potion.play_random()
        ToolBar.Tool.SUMMON:
            equip_summon.play_random()

func on_tool_action(tool_type: ToolBar.Tool) -> void:
    match tool_type:
        ToolBar.Tool.MAGIC_BOLT:
            do_attack.play_random()
        ToolBar.Tool.TORCH:
            do_torch.play_random()
        ToolBar.Tool.PICKAXE:
            do_pickaxe.play_random()
        ToolBar.Tool.POTION:
            do_potion.play_random()
        ToolBar.Tool.SUMMON:
            do_summon.play_random()
