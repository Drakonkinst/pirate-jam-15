extends Node2D

class_name Grid

@export var tile_scene: PackedScene
@export var num_rows := 5
@export var num_cols := 9
@export var tile_width := 150
@export var tile_height := 125
@export var offset: Vector2 = Vector2(30, -10)
@export var debug_marker_scene: PackedScene
@export var show_debug: bool = false

var grid: Array[Array]

# row = y, col = x
func get_tile(row: int, col: int) -> GridTile:
    row = clamp(0, row, num_rows - 1)
    col = clamp(0, col, num_cols - 1)
    return grid[row][col]

func is_valid_tile(row: int, col: int) -> bool:
    if row < 0 || row >= num_rows || col < 0 || col >= num_cols:
        return false
    return true

func find_grid_origin() -> Vector2:
    var screen_dimensions: Vector2 = get_viewport().get_visible_rect().size
    var grid_height: float = tile_height * num_rows
    var grid_width: float = tile_width * num_cols
    var origin_x := (screen_dimensions.x - grid_width) / 2
    var origin_y := (screen_dimensions.y - grid_height) / 2
    var origin: Vector2 = position + Vector2(origin_x, origin_y)
    origin += offset
    return origin

func screenspace_to_tile(screen_space_pos: Vector2) -> GridTile:
    var origin = find_grid_origin()
    var grid_offset = screen_space_pos - origin

    var row = floori(grid_offset.y / tile_height)
    var col = floori(grid_offset.x / tile_width)

    if not is_valid_tile(row, col):
        return null
    return get_tile(row, col)

func get_grid_row_at_pos(pos: Vector2) -> int:
    var origin = find_grid_origin()
    var grid_offset = pos - origin
    var row = floori(grid_offset.y / tile_height)
    return clamp(row, 0, num_rows - 1)

func should_ally_stop(tile: GridTile) -> bool:
    return tile.col == num_cols - 1

func should_enemy_stop(tile: GridTile) -> bool:
    return tile.col == 0

func get_min_x(tile: GridTile) -> float:
    return get_tile_center(tile).x - tile_width / 2.0

func get_y_extents() -> Vector2:
    var origin = find_grid_origin()
    var min_extent = origin.y + tile_height / 2.0
    var max_extent = origin.y + tile_height * num_rows
    return Vector2(min_extent, max_extent)

func get_tiles_in_radius(pos: Vector2, radius: float) -> Array[GridTile]:
    var result: Array[GridTile] = []
    for tile: GridTile in GridIterator.new(self):
        if is_tile_in_radius(tile, pos, radius):
            result.append(tile)
    return result

# https://stackoverflow.com/a/402010
func is_tile_in_radius(tile: GridTile, pos: Vector2, radius: float) -> bool:
    var tile_center: Vector2 = get_tile_center(tile)
    var delta_x = abs(pos.x - tile_center.x)
    var delta_y = abs(pos.y - tile_center.y)
    var half_width = tile_width / 2.0
    var half_height = tile_height / 2.0

    if delta_x > half_width + radius:
        return false
    if delta_y > half_height + radius:
        return false

    if delta_x <= half_width:
        return true
    if delta_y <= half_height:
        return true

    var half_x: float = delta_x - half_width
    var half_y: float = delta_y - half_height
    var corner_dist_sq = half_x * half_x + half_y * half_y
    return corner_dist_sq <= radius * radius

func _place_debug_circle(pos: Vector2):
    if not show_debug:
        return
    var obj = debug_marker_scene.instantiate()
    add_child(obj)
    obj.position = pos

func get_tile_center(tile: GridTile) -> Vector2:
    var origin = find_grid_origin()
    var tile_center_x: float = origin.x + tile.col * tile_width + (tile_width / 2.0)
    var tile_center_y: float = origin.y + tile.row * tile_height + (tile_height / 2.0)
    var pos = Vector2(tile_center_x, tile_center_y)
    return pos

func is_on_grid(pos: Vector2) -> bool:
    return screenspace_to_tile(pos) != null

func get_neighbors(center_tile: GridTile, allow_diagonal = false, allow_center = false) -> Array[GridTile]:
    var results: Array[GridTile] = []
    var center_row = center_tile.row
    var center_col = center_tile.col
    for row_offset in range(-1, 2):
        for col_offset in range(-1, 2):
            var magnitude = abs(row_offset) + abs(col_offset)
            if magnitude > 1 and not allow_diagonal:
                continue
            if magnitude == 0 and not allow_center:
                continue
            var row = center_row + row_offset
            var col = center_col + col_offset
            if not is_valid_tile(row, col):
                continue
            var tile: GridTile = get_tile(row, col)
            results.append(tile)
    return results

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

