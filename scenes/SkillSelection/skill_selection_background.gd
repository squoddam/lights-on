extends Control

@onready var backdrop: ColorRect = $Backdrop
@onready var round_label: Label = $RoundLabel
@onready var label_top_place: Node2D = $LabelTopPlace

var is_animating: bool = true

@onready var rect: Rect2 = get_rect()

var back_radius: int = 0
var back_position: Vector2 = Vector2(0.5, 0)

signal open_animation_start()
signal open_animation_end()
signal close_animation_end()

func _ready() -> void:
	backdrop.color = Color(Constants.COLORS.background)
	State.curr_round_change.connect(handle_curr_round_change)
	
	#handle_curr_round_change(2)
	
	round_label.position = Constants.WINDOW_SIZE / 2 - round_label.size / 2

func handle_curr_round_change(next_round: int) -> void:
	round_label.text = "round " + str(next_round)

	if next_round > 1:
		animate_open()

func animate_open() -> void:
	is_animating = true
	open_animation_start.emit()
	backdrop.animate_open()
	
	back_position = Vector2(rect.size.x / 2, -rect.size.x / 2)
	var from_radius: float = rect.size.x / 22
	var to_radius: float = rect.size.x + rect.size.y
	
	var t := create_tween()
	
	t.tween_property(self, "back_radius", to_radius, 1.).from(from_radius)
	#t.tween_property(round_label, "position", label_top_place.position - round_label.size / 2, 1.).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.parallel().tween_callback(open_animation_start.emit).set_delay(.5)
	t.tween_callback(func() -> void: is_animating = false)
	
	t.tween_callback(animate_close).set_delay(1.)

func animate_close() -> void:
	is_animating = true
	
	back_position = Vector2(rect.size.x / 2, rect.size.x + rect.size.y)
	
	var t := create_tween()
	
	t.tween_property(self, "back_radius", rect.size.x, 1.).from(rect.size.x + rect.size.y)
	t.tween_callback(func() -> void:
		is_animating = false
		top_level = false
		back_radius = 0
		
		close_animation_end.emit()
	)

func _draw() -> void:
	draw_circle(back_position, back_radius, Color.WHITE)

func _process(delta: float) -> void:
	if is_animating:
		queue_redraw()
