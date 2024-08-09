extends Node2D

class_name AudioManager

# Background Music
@onready var background_music: BackgroundMusic = %BackgroundMusic

# Pause
@onready var on_pause_audio: AudioRandomizer = %PauseAudio
@onready var off_pause_audio: AudioRandomizer = %UnpauseAudio

# Projectiles
@onready var splash_audio: AudioRandomizer = %SplashAudio
@onready var pickaxe_audio: AudioRandomizer = %PickaxeAudio
@onready var summon_audio: AudioRandomizer = %SummonAudio
@onready var death_audio: AudioRandomizer = %DeathAudio

@onready var fire_audio: FireAudio = %FireAudio
@onready var tool_bar_audio: ToolBarAudio = %ToolBarAudio

func _on_pause_control_paused() -> void:
    on_pause_audio.play()

func _on_pause_control_unpaused() -> void:
    off_pause_audio.play()

func _on_day_cycle_manager_day_started(curr_round: int) -> void:
    background_music.switch_track(curr_round)

func _on_day_cycle_manager_finished_final_round(curr_round: int) -> void:
    background_music.switch_track(curr_round)

func _on_tool_bar_do_action(tool_type: ToolBar.Tool) -> void:
    tool_bar_audio.on_tool_action(tool_type)

func _on_tool_bar_tool_changed(tool_type: ToolBar.Tool) -> void:
    tool_bar_audio.on_tool_changed(tool_type)

func _on_projectile_manager_ally_summoned() -> void:
    summon_audio.play_random()

func _on_projectile_manager_enemy_killed() -> void:
    death_audio.play_random()

func _on_projectile_manager_pickaxe_landed() -> void:
    pickaxe_audio.play_random()

func _on_projectile_manager_splash_spawned() -> void:
    splash_audio.play_random()
