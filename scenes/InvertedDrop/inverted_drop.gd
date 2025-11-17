extends CanvasGroup

class_name InvertedDrop

var radius: float = 0.

@onready var m: ShaderMaterial = material

func _ready() -> void:
	RenderingServer.global_shader_parameter_set("color1", Color(Constants.COLORS.cell))
	RenderingServer.global_shader_parameter_set("color2", Color(Constants.COLORS.background))

func animate(drop_position: Vector2, to_radius: float, duration: float, on_finish: Callable) -> void:
	m.set_shader_parameter("position", drop_position)
	
	var t: Tween = create_tween()
	
	t.tween_method(func(val: float) -> void:
		m.set_shader_parameter("radius", val),
		radius,
		to_radius,
		duration
		)
	t.tween_callback(on_finish)
	
