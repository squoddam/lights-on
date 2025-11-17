extends Control

class_name DirectionIcon

var arrow_res: Resource = preload("res://scenes/Cell/arrow_off.png")

@onready var base: Sprite2D = $Control/Base
@onready var arrows_container: Node2D = $Control/arrows

@export var delay := 0.3
@export var duration := 2.

var trans := Tween.TRANS_EXPO
var ease := Tween.EASE_OUT

func init(directions_amount: int) -> void:
	custom_minimum_size = Vector2.ONE * Constants.CELL_SIZE
	
	base.scale = Vector2.ONE * Constants.ASSET_SCALE
	base.modulate = Color(Constants.COLORS.cell)
	
	for i in directions_amount:
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = arrow_res
		
		sprite.scale = Vector2.ONE * Constants.ASSET_SCALE
		
		var angle: float = -(PI / 2) + (PI / 2) * i
		
		sprite.position = get_arrow_position(angle)
		
		sprite.modulate = Color(Constants.COLORS.cell)
		
		sprite.name = "Arrow" + str(i)
		
		arrows_container.add_child(sprite)
	
	animate(directions_amount)

func animate(directions_amount: int) -> void:
	match directions_amount:
		0: pass
		1:
			var t: Tween = create_tween()
			
			var arrow: Sprite2D = arrows_container.get_node("Arrow0")
			
			var angle := { "value": -PI/2 }
			
			t.set_loops()
			
			t.tween_method(
				func(val: float) -> void:
					arrow.position = get_arrow_position(angle.value + PI/2 * val),
				0., 1., duration).set_trans(trans).set_ease(ease)
			t.tween_callback(func() -> void: angle.value = fmod(angle.value + PI/2, TAU))
			t.tween_interval(delay)
		2:
			var t0: Tween = create_tween()
			var t1: Tween = create_tween()

			var arrows := arrows_container.get_children()
			
			var angle_0 := { "value": -PI/2 }
			var angle_1 := { "value": 0 }
			
			t0.tween_method(func(val: float) -> void:
				arrows[0].position = get_arrow_position(angle_0.value + PI/2 * val),
				0., 1., duration).set_trans(trans).set_ease(ease)
			t0.tween_interval(delay)
			t0.tween_callback(func() -> void: arrows[0].position = get_arrow_position(angle_0.value))
			t0.parallel().tween_callback(func() -> void: arrows[1].position = get_arrow_position(angle_1.value))
			
			t1.set_loops()
			
			for i in 3:
				t1.tween_method(func(val: float) -> void:
					arrows[1].position = get_arrow_position(angle_1.value + (PI/2 * i) + PI/2 * val),
					0., 1., duration).set_trans(trans).set_ease(ease)
				if i == 2:
					t1.parallel().tween_subtween(t0)
				else:
					t1.tween_interval(delay)
		3:
			var t: Tween = create_tween()
			
			t.set_loops()
			
			var arrows := arrows_container.get_children()
			
			for i in arrows.size():
				var arrow := arrows[arrows.size() - 1 - i]
				var angle := { "value": 0. }
				
				t.tween_callback(func() -> void:
					angle.value = (arrow.position / (Constants.CELL_SIZE / 2. * 0.5)).angle()
					)
				t.tween_method(func(val: float) -> void:
					arrow.position = get_arrow_position(angle.value + PI/2 * val),
					0., 1., duration).set_trans(trans).set_ease(ease)
				t.tween_interval(delay)
		4:
			var t: Tween = create_tween()
			
			t.set_loops()
			
			var arrows := arrows_container.get_children()
			
			for i in arrows.size():
				var arrow := arrows[i]
				var angle := { "value": 0. }
				
				t.parallel().tween_callback(func() -> void:
					angle.value = (arrow.position / (Constants.CELL_SIZE / 2 * 0.5)).angle()
					)
				t.parallel().tween_method(func(val: float) -> void:
					arrow.position = get_arrow_position(angle.value + PI/2 * val),
					0., 1., duration).set_trans(trans).set_ease(ease)
			
			t.chain().tween_interval(delay)

func get_arrow_position(angle: float) -> Vector2:
	var direction: Vector2 = Vector2(cos(angle), sin(angle))
		
	return direction * Constants.CELL_SIZE / 2 * 0.5
	
