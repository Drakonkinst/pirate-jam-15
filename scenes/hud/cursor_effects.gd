extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

@export var circle_area_texture: Texture2D

func _physics_process(_delta: float) -> void:
    var mouse_pos = get_global_mouse_position()
    global_position = mouse_pos

    # TODO: if potion/torch, only show reticle if in valid area

func _on_tool_bar_tool_changed(tool_type: ToolBar.Tool) -> void:
    match tool_type:
        ToolBar.Tool.POTION:
            sprite.show()
            sprite.texture = circle_area_texture
            _scale_sprite_to_size(GlobalVariables.POTION_RADIUS * 2)
        ToolBar.Tool.TORCH:
            sprite.show()
            sprite.texture = circle_area_texture
            _scale_sprite_to_size(50)
        ToolBar.Tool.MAGIC_BOLT:
            sprite.hide()


func _scale_sprite_to_size(size: float) -> void:
    var texture_width = sprite.texture.get_width()
    var texture_height = sprite.texture.get_height()
    sprite.scale.x = size / texture_width
    sprite.scale.y = size / texture_height
