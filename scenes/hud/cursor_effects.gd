extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

@export var circle_area_texture: Texture2D

var current_tool_type: ToolBar.Tool

func _physics_process(_delta: float) -> void:
    _update_cursor()

func _update_cursor() -> void:
    var mouse_pos = get_global_mouse_position()
    global_position = mouse_pos

    # TODO: if potion/torch, only show reticle if in valid area
    if current_tool_type == ToolBar.Tool.POTION || current_tool_type == ToolBar.Tool.TORCH:
        var should_show = GlobalVariables.get_projectile_manager().is_valid_target(mouse_pos, true)
        var toolbar: ToolBar = GlobalVariables.get_toolbar()
        if current_tool_type == ToolBar.Tool.POTION and toolbar.tool_inventory.get_potion_count(toolbar.selected_potion) <= 0:
            should_show = false
        if should_show:
            sprite.show()
        else:
            sprite.hide()

func _on_tool_bar_tool_changed(tool_type: ToolBar.Tool) -> void:
    current_tool_type = tool_type
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
        ToolBar.Tool.PICKAXE:
            sprite.show()
            sprite.texture = circle_area_texture
            _scale_sprite_to_size(50)
            # sprite.hide()
        ToolBar.Tool.SUMMON:
            # sprite.show()
            # sprite.texture = circle_area_texture
            # _scale_sprite_to_size(50)
            sprite.hide()
    _update_cursor()


func _scale_sprite_to_size(size: float) -> void:
    var texture_width = sprite.texture.get_width()
    var texture_height = sprite.texture.get_height()
    sprite.scale.x = size / texture_width
    sprite.scale.y = size / texture_height
