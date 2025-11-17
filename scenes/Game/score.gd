extends Label

@onready var player: AudioStreamPlayer2D = $"../../../AudioStreamPlayer2D"

var curr_score := 0

var t: Tween
var true_position: Vector2

func get_score_text(score: int) -> String:
	return str(score)

func _ready() -> void:
	State.score_node = self
	State.score_change.connect(handle_score_change)
	
	text = get_score_text(curr_score)

func handle_score_change(next_score: int) -> void:
	if t != null && t.is_running():
		t.stop()
	
	t = create_tween()
	
	t.tween_method(func(val: int) -> void: 
		text = get_score_text(val)
		if curr_score != val:
			player.play()
		curr_score = val, 
		curr_score, next_score, 0.1)
