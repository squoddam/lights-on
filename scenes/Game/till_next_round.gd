extends Label

var curr_score_goal: int = 0

func _ready() -> void:
	State.score_change.connect(handle_score_change)
	State.score_goal_change.connect(handle_score_goal_change)
	
func handle_score_goal_change(score_goal: int) -> void:
	var t: Tween = create_tween()
	
	t.tween_method(func(val: int) -> void: 
		text = get_score_left_text(val - State.score)
		curr_score_goal = val, 
		curr_score_goal, score_goal, 0.1)

func handle_score_change(next_score: int) -> void:
	if next_score > curr_score_goal:
		return
		
	text = get_score_left_text(curr_score_goal - next_score)

func get_score_left_text(score_left: int) -> String:
	return "%s till next round" % [score_left]
