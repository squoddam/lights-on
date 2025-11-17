extends Label

func _ready() -> void:
	State.curr_round_change.connect(handle_curr_round_change)

func handle_curr_round_change(curr_round: int) -> void:
	text = "round " + str(curr_round)
