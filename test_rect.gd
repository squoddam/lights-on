extends CanvasGroup

@export var duration: float = 1.

var is_reversed: bool = false

func _ready() -> void:
	var mat: ShaderMaterial = material
	
	var t := create_tween()
	
	t.set_loops()
	
	t.tween_method(func(val: float) -> void:
		mat.set_shader_parameter("radius", 1. - val if is_reversed else val), 0., 1., duration)
	t.tween_callback(func() -> void: is_reversed = !is_reversed)
