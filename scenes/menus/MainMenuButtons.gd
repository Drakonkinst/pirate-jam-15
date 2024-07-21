extends CanvasLayer

@onready var game_scene = "res://scenes/main.tscn"

@onready var audio_player = %AudioStreamPlayer

var sfx_path = "res://assets/audio/sfx/"

var sounds = {
	startup = load(sfx_path + "select_006.ogg"),
	select_play = load(sfx_path + "confirmation_002.ogg"),
	toggle_option = load(sfx_path + "toggle_004.ogg"),
    select_settings = load(sfx_path + "select_002.ogg"),
    select_return = load(sfx_path + "bong_001.ogg")
}

func _ready():
    play_sound(sounds.startup)

# Sound utility
func play_sound(sound):
    audio_player.stream = sound
    audio_player.play()

# Menu Utility
func toggle_menu(menu_node):
    var start_menu = %StartMenu
    menu_node.visible = not menu_node.visible
    start_menu.visible = not start_menu.visible

func switch_to_scene(scene_path):
    get_tree().change_scene_to_file(scene_path)

func _on_play_button_mouse_down():
    play_sound(sounds.select_play)
    call_deferred("switch_to_scene",game_scene)

func _on_settings_button_button_down():
    play_sound(sounds.toggle_option)
    var settings_menu = %SettingsMenu
    toggle_menu(settings_menu) 

func _on_credits_button_mouse_down():
	# Toggle settings page
    pass

func _on_exit_button_mouse_down():
    play_sound(sounds.select_return)
    await get_tree().create_timer(0.5).timeout
    get_tree().quit()


func _on_return_button_button_down():
    play_sound(sounds.select_return)
    toggle_menu(%SettingsMenu)
