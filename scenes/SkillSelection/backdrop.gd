extends ColorRect

var is_animating: bool = true

#@onready var rect: Rect2 = get_rect()
var rect: Rect2 = Rect2(Vector2.ZERO, Constants.WINDOW_SIZE)

var back_radius: int = 0
var back_position: Vector2 = Vector2(0.5, 0)

func _draw() -> void:
	draw_circle(back_position, back_radius - Constants.CELL_SIZE / 2., Color(Constants.COLORS.background))
	draw_circle(back_position, back_radius, Color(Constants.COLORS.cell), false, 4)

func _process(delta: float) -> void:
	if is_animating:
		queue_redraw()

func animate_open() -> void:
	is_animating = true
	
	back_position = Vector2(rect.size.x / 2, -rect.size.x / 2)
	var from_radius: float = (rect.size.x / 22) * 1
	var to_radius: float = (rect.size.x + rect.size.y) * 1
	
	var t: Tween = create_tween()
	
	t.tween_property(self, "back_radius", to_radius, 1.).from(from_radius)
	t.tween_callback(func() -> void: is_animating = false)
