extends Control

class_name Cell

@onready var on_state: Node2D = $on
@onready var off_state: Node2D = $off

var is_tweening := false

var index: int = 0
var id: int
var coords: Vector2i

var is_on: bool = false
var directions: Array[String] = []

func _ready() -> void:
	apply_scale()
	size = Vector2.ONE * Constants.CELL_SIZE
	
	State.press_cell.connect(handle_press_cell)
	State.tick_finish.connect(handle_tick_finish)
	State.process_chain_finish.connect(handle_process_chain_finish)
	
	var cell: Dictionary = State.level[id]
	
	coords = cell.coords
	
	update_all_arrows(cell.directions)
	
	is_on = cell.is_on
	
	modulate = Color(Constants.COLORS.cell)

func apply_scale() -> void:
	for state: Node2D in get_children():
		state.position += Vector2.ONE * Constants.CELL_SIZE / 2
		(state.get_node("base") as Node2D).scale = Vector2.ONE * Constants.ASSET_SCALE
		
		for arrow: Node2D in state.get_node("arrows").get_children():
			arrow.scale = Vector2.ONE * Constants.ASSET_SCALE
			
			var dir: Vector2i = Constants.DIRECTIONS_MAP[arrow.name]
			
			arrow.position = dir * (Constants.CELL_SIZE / 2.) * 0.5

func update_all_arrows(cell_directions: Array) -> void:
	directions.assign(cell_directions)
	
	for dir: String in cell_directions:
		var node_path: String = "arrows/%s" % [dir]

		off_state.get_node(node_path).visible = true
		on_state.get_node(node_path).visible = true

func _on_gui_input(event: InputEvent) -> void:
	if !State.is_blocked && event.is_pressed() && !is_tweening:
		State.press_cell.emit([Vector2i.ZERO, id])

func handle_press_cell(tick_data: Array, chain_index: int = 0) -> void:
	if id == tick_data[1]:
		is_on = !is_on

		is_tweening = true

		on_state.animate(chain_index, tick_data[0], func() -> void: is_tweening = false)

@warning_ignore("unused_parameter")
func handle_process_chain_finish(changes: Dictionary) -> void:
	var index_in_chain: int = State.curr_chain.find(id)
	
	if index_in_chain != -1:
		move_to_score(index_in_chain == State.curr_chain.size() - 1, index_in_chain)

func move_to_score(is_last: bool, index_in_chain: int) -> void:
	z_index = 1

	var tween: Tween = create_tween()
	
	tween.set_ease(Tween.EASE_IN)
	var base_delay := index_in_chain * 0.02
	
	tween.tween_property(self, "global_position", State.score_node.global_position + State.score_node.size / 2, 0.5).set_delay(base_delay).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.2).set_delay(base_delay + 0.3)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.1).set_delay(base_delay + 0.4)
	
	tween.parallel().tween_callback(func() -> void:
		State.score += 1
		
		if is_last:
			State.score_change_finish.emit()
	).set_delay(base_delay + 0.4)
	
	tween.tween_callback(queue_free)

func handle_tick_finish(tick_queue: Array) -> void:
	var tick_index: int = tick_queue.find_custom(func(tick: Array) -> bool: return tick[1] == id)

	if tick_index != -1:
		var tick_data: Array = tick_queue[tick_index]
		handle_press_cell(tick_data, State.curr_chain.size() if tick_index == 0 else -1)

func move(amount_to_move: int) -> void:
	var cell: Dictionary = State.level[id]
	var to_coords: Vector2i = cell.coords + Vector2i(0, amount_to_move)
	var to_position: Vector2 = to_coords * Constants.CELL_WITH_GAP
		
	var t: Tween = create_tween()
	
	t.tween_property(self, "position", to_position, 0.3)
	
	if cell.coords.y < 0:
		t.parallel().tween_property(self, "modulate:a", 1, 0.3).from(0)
	
	t.tween_callback(func() -> void:
		var updated_cell: Dictionary = State.level[id].merged({ "coords": to_coords }, true)
		
		State.add_to_level(
			id,
			updated_cell
		)
	)
