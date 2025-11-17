extends Node

var is_blocked := false

var score_node: Label

var level: Dictionary = {}
var coords_map: Dictionary[Vector2i, int]
var last_id := 0
#var side_size := 0
var curr_chain: Array[int] = []
var score: int = 0:
	set(next_score):
		score_change.emit(next_score)
		
		score = next_score

var turns_left: int = 5:
	set(next_turns_left):
		turns_left_change.emit(next_turns_left)
		
		turns_left = next_turns_left

var turns_per_round: int = 5:
	set(next_turns_per_round):
		turns_per_round_change.emit(next_turns_per_round)
		
		turns_per_round = next_turns_per_round

var curr_round: int = 1:
	set(next_curr_round):
		curr_round_change.emit(next_curr_round)
		
		curr_round = next_curr_round

var round_multiplier: float = 1.5:
	set(next_round_multiplier):
		round_multiplier_change.emit(next_round_multiplier)
		
		round_multiplier = next_round_multiplier

var score_goal: int = 25:
	set(next_score_goal):
		score_goal_change.emit(next_score_goal)
		
		score_goal = next_score_goal

var directions_weights: Array[Array] = [
	[0, 5],
	[1, 75],
	[2, 15],
	[3, 4],
	[4, 1]
]

var multipler_possibility_weight := 10
var multipliers_weight: Array[Array] = [
	[2, 10]
]

var skills_weights: Array[Array]

var curr_skills: Array[Dictionary] = []

signal init_signal()
signal press_cell(cell_id: int)
signal tick_finish(tick_queue: Array)
signal process_chain_start(chain: Array[int])
signal process_chain_finish(changes: Dictionary)

signal score_change(next_score: int)
signal score_change_finish()
signal turns_left_change(turns_left: int)
signal turns_per_round_change(turns_per_round: int)
signal curr_round_change(curr_round: int)
signal round_multiplier_change(round_multiplier: int)
signal score_goal_change(score_goal: int)
signal game_over()

signal add_skill(index: int, skill: Dictionary)

func _ready() -> void:
	for dir_skill: Dictionary in Skills.direction_skills:
		for tier: int in dir_skill.tiers:
			skills_weights.append([{
				"type": dir_skill.type,
				"directions_amount": dir_skill.directions_amount,
				"change": tier
			}, 1])
	
	for multipler_skill: Dictionary in Skills.multiplier_skills:
		for tier: int in multipler_skill.tiers:
			skills_weights.append([{
				"type": multipler_skill.type,
				"multiply_by": multipler_skill.multiply_by,
				"change": tier
			}, 1])

func get_rand_skills(amount: int) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	
	var sum: int = skills_weights.reduce(func(acc: int, weight: Array) -> int: return acc + weight[1], 0)
	
	for amount_i: int in amount:
		var r: float = randf() * sum
		
		var curr_sum: int = 0
		var is_found: bool = false
		for skill_weight_index in skills_weights.size():
			if is_found:
				skills_weights[skill_weight_index][1] += 1
				continue
			
			var weight: int = skills_weights[skill_weight_index][1]
			
			curr_sum += weight
			
			if curr_sum >= r:
				is_found = true
				result.append(skills_weights[skill_weight_index][0])
			else:
				skills_weights[skill_weight_index][1] += 1
	
	return result

func update_coords_map() -> void:
	coords_map.assign(level.keys().reduce(func(res: Dictionary, cell_id: int) -> Dictionary:
		res[level[cell_id].coords] = cell_id
		return res,
	{}))

func set_level(next_level: Dictionary) -> void:
	level.assign(next_level)
	
	update_coords_map()

func add_to_level(cell_id: int, cell: Dictionary) -> void:
	level[cell_id] = cell
	
	update_coords_map()

func remove_from_level(cell_id: int) -> void:
	level.erase(cell_id)
	
	update_coords_map()

var is_init: bool = false

func init() -> void:
	set_level(generate_chain_rand_level())
	
	score = 0
	curr_round = 1
	score_goal = 25
	turns_left = turns_per_round
	
	if !is_init:
		press_cell.connect(handle_press_cell)
		process_chain_start.connect(handle_process_chain_start)
		score_change_finish.connect(handle_score_change_finish)
		add_skill.connect(handle_add_skill)
	
	init_signal.emit()
	is_blocked = false
	is_init = true

var tick_duration: float = .3
var since_last_tick: float = 0

func _process(delta: float) -> void:
	since_last_tick += delta
	
	if since_last_tick > tick_duration && tick_queue.size() > 0:
		tick()
		since_last_tick = 0

var tick_queue: Array = []

func toggle(obj: Dictionary, prop_name: String) -> void:
	obj[prop_name] = !obj[prop_name]

func tick() -> void:
	var next_queue: Array = []
	
	for tick_data: Array in tick_queue:
		var cell_id: int = tick_data[1]
		
		curr_chain.append(cell_id)
		var cell: Dictionary = level[cell_id]
		
		cell.is_on = true
		
		for dir: String in cell.directions:
			var neighbour_coords: Vector2i = cell.coords + Constants.DIRECTIONS_MAP[dir]
			
			if coords_map.has(neighbour_coords):
				var neighbour_id: int = coords_map[neighbour_coords]
				
				if !curr_chain.has(neighbour_id) && next_queue.find_custom(func(t: Array) -> bool: return t[1] == neighbour_id) == -1:
					next_queue.append([neighbour_coords - cell.coords, neighbour_id])
	
	if next_queue.is_empty():
		process_chain_start.emit(curr_chain)

	tick_queue.assign(next_queue)
	tick_finish.emit(next_queue)

func randb() -> bool:
	return randi() % 2 == 0

func is_at_edge(direction: String, index: int, size: int) -> bool:
	var col: int = index % size
	@warning_ignore("integer_division")
	var row: int = index / size
	
	match(direction):
		"N":
			return row == 0
		"E":
			return col == size - 1
		"S":
			return row == size - 1
		"W":
			return col == 0
	
	return false

func pick_random(arr: Array[Variant], amount: int = 1) -> Variant:
	var picked: Array[Variant] = []
	
	var capped_amount: int = min(arr.size(), amount)
	
	while picked.size() < capped_amount:
		var random_pick: Variant = arr.filter(func(item: Variant) -> bool: return !picked.has(item)).pick_random()
		
		picked.append(random_pick)
	
	return picked

func pick_random_with_weights(arr: Array[Array]) -> Variant:
	var sum: float = arr.reduce(func(acc: float, option: Array) -> float: return acc + option[1], 0.)
	
	var rand_res: float = randf() * sum
	
	var option_acc: float = 0.
	
	for option: Array in arr:
		option_acc += option[1]
		if rand_res < option_acc:
			return option[0]
		else: continue
	
	return arr[0]

func generate_cell(coords: Vector2i) -> Dictionary:
	var curr_possible_directions: Array = Constants.POSSIBLE_DIRECTIONS.duplicate()
		
	if coords.x <= 0:
		curr_possible_directions = curr_possible_directions.filter(func(dir: String) -> bool: return dir != "W")
	
	if coords.x >= Constants.BOARD_CELLS_SIZE - 1:
		curr_possible_directions = curr_possible_directions.filter(func(dir: String) -> bool: return dir != "E")
		
	if coords.y <= 0:
		curr_possible_directions = curr_possible_directions.filter(func(dir: String) -> bool: return dir != "N")
	
	if coords.y >= Constants.BOARD_CELLS_SIZE - 1:
		curr_possible_directions = curr_possible_directions.filter(func(dir: String) -> bool: return dir != "S")

	var dir_amounts: Array[Array] = directions_weights.filter(func(weight: Array) -> bool: return weight[0] <= curr_possible_directions.size())

	var rand_dir_amount: int = 0
	
	if dir_amounts.size() > 0:
		rand_dir_amount = pick_random_with_weights(dir_amounts)
	
	var cell: Dictionary = {
		"id": last_id,
		"coords": coords,
		"directions": pick_random(curr_possible_directions, rand_dir_amount),
		"is_on": false
	}
	
	coords_map[coords] = last_id
	
	last_id += 1
	
	return cell

func generate_chain_rand_level() -> Dictionary:
	#var size: int = randi_range(3, 6)
	var size: int = Constants.BOARD_CELLS_SIZE
	#side_size = size
	
	var level_size: int = size ** 2
	
	var next_level: Dictionary = {}
	
	for i in level_size:
		var col: int = i % size
		@warning_ignore("integer_division")
		var row: int = floor(i / size)

		var coords: Vector2i = Vector2i(col, row)

		var next_cell: Dictionary = generate_cell(coords)
		
		next_level[next_cell.id] = next_cell
	
	return next_level

func handle_press_cell(tick_data: Array) -> void:
	since_last_tick = 0
	curr_chain = []
	tick_queue.assign([tick_data])
	
	is_blocked = true
	turns_left -= 1

func handle_process_chain_start(chain: Array[int]) -> void:
	var to_add: Dictionary = {}
	var to_move: Dictionary = {}

	for cell_id in curr_chain:
		if level.has(cell_id):
			var cell: Dictionary = level[cell_id]
			
			for y: int in cell.coords.y:
				var update_coords := Vector2i(cell.coords.x, y)
				
				if !coords_map.has(update_coords):
					continue
				
				var update_cell_id: int = coords_map[update_coords]
				
				if !curr_chain.has(update_cell_id) && level.has(update_cell_id):
					#level[update_cell_id].coords.y += 1
					
					if !to_move.has(update_cell_id):
						to_move[update_cell_id] = 0
					
					to_move[update_cell_id] += 1
			
			if !to_add.has(cell.coords.x):
				to_add[cell.coords.x] = 0
			
			to_add[cell.coords.x] += 1
			
			remove_from_level(cell_id)
	
	for col: int in to_add:
		var amount_to_add: int = to_add[col]
		
		for i: int in amount_to_add:
			var coords := Vector2i(col, -(i + 1))
			var cell: Dictionary = generate_cell(coords)
			
			to_move[cell.id] = amount_to_add
			
			level[cell.id] = cell
	
	process_chain_finish.emit({
		"to_move": to_move,
		"to_remove": chain
	})

func handle_score_change_finish() -> void:
	if score >= score_goal:
		curr_round += 1
		turns_left = turns_per_round
		score_goal += floor(score_goal * round_multiplier)
	
	if turns_left == 0:
		game_over.emit()
		return
	
	is_blocked = false

func handle_add_skill(index: int, skill: Dictionary) -> void:
	curr_skills.append(skill)
