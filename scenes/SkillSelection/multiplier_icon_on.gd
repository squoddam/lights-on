extends Node2D

@onready var back: Sprite2D = $BackOn

var curr_direction_index: int = 0
var curr_direction_dir: int = 1

var open_radius: float = Constants.CELL_SIZE * 2.
var closed_radius: float = Constants.CELL_SIZE / 2.

var curr_radius: float = closed_radius

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	
	clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	var t: Tween = create_tween()
	
	t.set_loops()

	t.tween_property(self, "curr_radius", open_radius, .3)
	t.tween_interval(2)
	t.tween_callback(func() -> void: 
		curr_direction_dir *= -1)
	t.tween_property(self, "curr_radius", closed_radius, .3)
	t.tween_interval(2)
	t.tween_callback(func() -> void: curr_direction_index = (curr_direction_index + 1) % 4)

func _draw() -> void:
	var curr_direction: Vector2i = Constants.DIRECTIONS_MAP.values()[curr_direction_index]
	var from_position: Vector2 = Vector2(curr_direction) * Constants.CELL_SIZE * curr_direction_dir
	
	draw_circle(from_position, curr_radius, Color.WHITE)

func _process(delta: float) -> void:
	queue_redraw()
	#var curr_direction: Vector2i = Constants.DIRECTIONS_MAP.values()[curr_direction_index]
	#var from_position: Vector2 = Vector2(curr_direction) * curr_direction_dir
	#
	#(material as ShaderMaterial).set_shader_parameter("position", from_position)
	#(material as ShaderMaterial).set_shader_parameter("radius", curr_radius / Constants.CELL_SIZE)
