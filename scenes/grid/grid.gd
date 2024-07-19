extends Node2D

class_name Grid

@export var tile_scene: PackedScene
@export var num_rows := 5
@export var num_cols := 9
@export var tile_width := 150
@export var tile_height := 125

var grid: Array[Array]

# row = y, col = x
func get_tile(row: int, col: int) -> GridTile:
    row = clamp(0, row, num_rows - 1)
    col = clamp(0, col, num_cols - 1)
    return grid[row][col]

func find_grid_origin():
    # Not sure why this doesn't fully center it but we're applying an offset anyways
    var screen_dimensions: Vector2 = get_viewport().get_visible_rect().size
    var grid_height: float = tile_height * num_rows
    var grid_width: float = tile_width * num_cols
    var origin_x := (screen_dimensions.x - grid_width) / 2
    var origin_y := (screen_dimensions.y - grid_height) / 2
    print(screen_dimensions, " ", grid_height, " ", grid_width)
    var origin: Vector2 = position + Vector2(origin_x, origin_y)
    return origin

func _ready():
    var origin: Vector2 = find_grid_origin()
    for row in num_rows:
        var row_tiles: Array[GridTile] = []
        for col in num_cols:
            var tile_obj = tile_scene.instantiate()
            add_child(tile_obj)
            var tile = tile_obj as GridTile
            tile.initialize(origin, row, col, tile_width, tile_height)
            row_tiles.append(tile)
        grid.append(row_tiles)

