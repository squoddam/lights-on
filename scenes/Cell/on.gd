extends Node2D

var final_radius := 0.
var curr_radius := 0
var from_position := Vector2.ZERO

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

func animate(chain_index: int, direction: Vector2i, on_finish: Callable) -> void:
	final_radius = Constants.CELL_SIZE * 1.5 + Constants.GAP
	var is_chain_head := direction == Vector2i.ZERO
	from_position = -Vector2(direction) * Constants.CELL_SIZE / 2
	
	var t: Tween = create_tween()
	
	t.tween_property(self, "curr_radius", final_radius, .8 if is_chain_head else .6)
	t.parallel().tween_callback(func() -> void:
		if chain_index > -1:
			audio.pitch_scale += chain_index * 0.05
			audio.play()
	)
	t.tween_callback(on_finish)

func _draw() -> void:
	draw_circle(from_position, curr_radius, Color.WHITE)

func _process(delta: float) -> void:
	if curr_radius != final_radius:
		queue_redraw()
