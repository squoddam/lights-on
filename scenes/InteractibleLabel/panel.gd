extends Panel

signal click_event()

var radius: int:
	set(next_radius):
		custom_stylebox.corner_radius_bottom_left = next_radius
		custom_stylebox.corner_radius_bottom_right = next_radius
		custom_stylebox.corner_radius_top_left = next_radius
		custom_stylebox.corner_radius_top_right = next_radius
		
		radius = next_radius

var custom_stylebox: StyleBoxFlat
var tween: Tween

func _ready() -> void:
	custom_stylebox = get_theme_stylebox("panel").duplicate()
	
	add_theme_stylebox_override("panel", custom_stylebox)
	
	custom_stylebox.bg_color = Color(1, 1, 1, 0.2)
	
	mouse_default_cursor_shape = CursorShape.CURSOR_POINTING_HAND
	
	connect("gui_input", handle_giu_input)
	connect("mouse_entered", handle_mouse_entered)
	connect("mouse_exited", handle_mouse_exited)

func tween_bg_color_to(to_color: Color, from_color: Color = custom_stylebox.bg_color) -> void:
	if tween != null:
		tween.stop()
		tween = null
		
	tween = get_tree().create_tween()
	
	tween.tween_property(custom_stylebox, "bg_color", to_color, 0.3).from(from_color)

func handle_giu_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		click_event.emit()
		
		tween_bg_color_to(Color(1, 1, 1, 0.3), Color(1, 1, 1, 0.7))

func handle_mouse_entered() -> void:
	tween_bg_color_to(Color(1, 1, 1, 0.3))
	

func handle_mouse_exited() -> void:
	tween_bg_color_to(Color(1, 1, 1, 0.2))
		
