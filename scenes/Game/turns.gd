extends Label

func get_label_text(turns_left: int) -> String:
	return str(turns_left) + " turns left"

func _ready() -> void:
	State.turns_left_change.connect(handle_turns_left_change)

	text = get_label_text(State.turns_left)

func handle_turns_left_change(turns_left: int) -> void:
	text = get_label_text(turns_left)
	
	var t: Tween = create_tween()
	
	var initial_a: float = label_settings.font_color.a
	
	t.tween_property(self, "label_settings:font_color:a", 1., .1).from(initial_a)
	t.tween_property(self, "label_settings:font_color:a", initial_a, .3).from(1.)
