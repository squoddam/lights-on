extends Control

func _ready() -> void:
	custom_minimum_size = Vector2.ONE * Constants.CELL_SIZE
	
	for state: CanvasItem in get_child(0).get_children():
		var base: Node2D = state.get_child(0)
		base.scale = Vector2.ONE * Constants.ASSET_SCALE
		base.modulate = Color(Constants.COLORS.cell)
