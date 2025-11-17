extends Node

var WINDOW_SIZE: Vector2 = Vector2(720, 1280)

var ASSET_BASE: int = 256

var BOARD_WIDTH_RATIO: float = 0.9
var BOARD_SIZE: float = WINDOW_SIZE.x * BOARD_WIDTH_RATIO

var BOARD_CELLS_SIZE: int = 7

#var CELL_SIZE: float = ASSET_BASE * ASSET_SCALE
var GAP: int = 5
var CELL_SIZE: float = (BOARD_SIZE - (GAP * (BOARD_CELLS_SIZE - 1))) / BOARD_CELLS_SIZE

var ASSET_SCALE: float = CELL_SIZE / ASSET_BASE

var CELL_WITH_GAP: float = CELL_SIZE + GAP

var COLORS: Dictionary = {
	"cell": "#FFD6C0",
	"background": "#25282D"
}

var POSSIBLE_DIRECTIONS: Array[String] = ["N", "E", "S", "W"]

var DIRECTIONS_MAP: Dictionary[String, Vector2i] = {
	"N": Vector2i(0, -1),
	"E": Vector2i(1, 0),
	"S": Vector2i(0, 1),
	"W": Vector2i(-1, 0),
}

var OPPOSITE_DIR_MAP: Dictionary = {
	"N": "S",
	"S": "N",
	"W": "E",
	"E": "W"
}
