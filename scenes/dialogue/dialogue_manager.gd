extends CanvasLayer

class_name DialogueManager

signal finish_conversation

const CHARACTERS_PER_SECOND := 20
const CLICK_INPUT := "click"
const CLOSE_DIALOGUE_INPUT := "close_dialogue"
const PROP_FONT_COLOR := "theme_override_colors/font_color"

const PLAYER_DEFAULT := "player"
const VILLAIN_DEFAULT := "villain"
const MINION_DEFAULT := "minion"

@export var textbox: Label
@export var speaker: Label
@export var pause_control: PauseControl
@onready var overlay: TextureRect = $DialogueOverlay
@onready var dialogue_container: Control = $DialogueBox

# To support multiple expressions, just make another speaker object + portrait
@export var player_default_portrait: TextureRect
@export var villain_default_portrait: TextureRect
@export var minion_default_portrait: TextureRect

# Temp export for testing
@export var current_conversation: Conversation

var active: bool = false
var typing: bool = false

# Manage the active conversation
var current_step: int
var num_chars_in_line: int
var line_progress: float

func _process(delta: float) -> void:
    if not active:
        return
    if typing:
        line_progress += CHARACTERS_PER_SECOND * delta
        textbox.visible_ratio = min(1.0, line_progress / num_chars_in_line)
        if line_progress >= num_chars_in_line:
            typing = false
    print(get_tree().paused)

func enable() -> void:
    get_tree().paused = true
    active = true
    overlay.show()
    dialogue_container.show()
    pause_control.disable()

func disable() -> void:
    get_tree().paused = false
    active = false
    overlay.hide()
    dialogue_container.hide()
    current_conversation = null
    pause_control.enable()

func play_conversation(conversation: Conversation) -> void:
    enable()
    current_conversation = conversation
    current_step = -1
    advance_step()

func advance_step() -> void:
    current_step += 1
    if current_step >= current_conversation.lines.size():
        end_conversation()
        return
    var line: ConversationLine = current_conversation.lines[current_step]
    update_portrait(line.speaker.id)
    speaker.text = line.speaker.name
    textbox.text = line.text
    textbox.set(PROP_FONT_COLOR, line.speaker.text_color)
    num_chars_in_line = line.text.length()
    typing = true
    line_progress = 0.0

func update_portrait(speaker_id: String) -> void:
    player_default_portrait.visible = speaker_id == PLAYER_DEFAULT
    villain_default_portrait.visible = speaker_id == VILLAIN_DEFAULT
    minion_default_portrait.visible = speaker_id == MINION_DEFAULT

func skip_to_next_line() -> void:
    if typing:
        textbox.visible_ratio = 1.0
        typing = false
    else:
        advance_step()

func end_conversation() -> void:
    finish_conversation.emit()
    disable()

func _unhandled_input(event: InputEvent) -> void:
    if not active:
        return
    if event.is_action_pressed(CLICK_INPUT):
        skip_to_next_line()
    if event.is_action_pressed(CLOSE_DIALOGUE_INPUT):
        end_conversation()
