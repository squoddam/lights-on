extends Control

@onready var CellScene: PackedScene = load("res://scenes/Cell/Cell.tscn")

var is_init: bool = false

func _ready() -> void:
	State.init_signal.connect(handle_init)
	State.process_chain_finish.connect(handle_process_chain_finish)
	
	State.init()

func handle_init() -> void:
	if is_init == false:
		@warning_ignore("integer_division")
		custom_minimum_size = Vector2.ONE * Constants.BOARD_SIZE
		
		position = Constants.WINDOW_SIZE / 2 - custom_minimum_size / 2
	else:
		for cell in get_children():
			cell.queue_free()
	
	is_init = true
	
	for cell_id: int in State.level:
		add_cell(cell_id)
	
	await get_tree().process_frame
	
	var t: Tween = create_tween()
	
	t.tween_property(self, "position", position, 0.5).from(position - Vector2(0, 100))
	t.parallel().tween_property(self, "modulate:a", 1, 0.5).from(0)

func get_cell_name(cell_id: int) -> String:
	return "Cell %s" % [cell_id]

func handle_process_chain_finish(change: Dictionary) -> void:
	await get_tree().create_timer(State.curr_chain.size() * 0.02 + 0.4).timeout
	
	for cell_id: int in change.to_move:
		var amount_to_move: int = change.to_move[cell_id]
		var cell_node: Control = get_node_or_null(get_cell_name(cell_id))
		
		if cell_node == null:
			cell_node = add_cell(cell_id)
		
		cell_node.move(amount_to_move)

func add_cell(cell_id: int) -> Control:
	var cell: Dictionary = State.level[cell_id]
		
	var cell_instance: Cell = CellScene.instantiate()
	
	cell_instance.id = cell.id
	
	cell_instance.position = Vector2(cell.coords) * Constants.CELL_WITH_GAP
	
	add_child(cell_instance)
	
	cell_instance.name = "Cell %s" % [cell.id]
	
	return cell_instance
