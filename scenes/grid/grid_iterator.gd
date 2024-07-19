# https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_advanced.html#custom-iterators
class_name GridIterator

var grid: Grid
var row: int = 0
var col: int = 0

func _init(g: Grid):
    grid = g

func should_continue() -> bool:
    return row < grid.num_rows

func _iter_init(_arg) -> bool:
    row = 0
    col = 0
    return should_continue()

func _iter_next(_arg) -> bool:
    col += 1
    if col >= grid.num_cols:
        col = 0
        row += 1
    return should_continue()

func _iter_get(_arg) -> GridTile:
    print(row, " ", col)
    return grid.get_tile(row, col)
