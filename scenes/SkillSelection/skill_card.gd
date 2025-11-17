extends Control

class_name SkillCard

@onready var panel: Panel = $Panel
@onready var skill_icon: SkillIcon = $Panel/MarginContainer/Control/SkillIcon
@onready var description_node: Label = $Panel/MarginContainer/Control/Description

var index: int
var skill: Dictionary

var style_box: StyleBoxFlat

func init(skill_to_init: Dictionary, description: String, skill_index: int) -> void:
	index = skill_index
	skill = skill_to_init
	size = panel.custom_minimum_size
	custom_minimum_size = panel.custom_minimum_size
	
	style_box = panel.get_theme_stylebox("panel")
	style_box.bg_color = Color(Constants.COLORS.background)
	
	panel.add_theme_stylebox_override("panel", style_box)
	
	skill_icon.init(skill_to_init)
	description_node.text = description

	panel.mouse_entered.connect(handle_mouse_entered)
	panel.mouse_exited.connect(handle_mouse_exited)
	panel.gui_input.connect(handle_gui_input)

func handle_mouse_entered() -> void:
	set_border_width(style_box, 10)

func handle_mouse_exited() -> void:
	set_border_width(style_box, 2)

func set_border_width(sb: StyleBoxFlat, width: int) -> void:
	var t := create_tween()

	t.tween_method(func(val: int) -> void:
		sb.border_width_bottom  = val
		sb.border_width_left = val
		sb.border_width_right = val
		sb.border_width_top = val
		panel.add_theme_stylebox_override("panel", sb),
		sb.border_width_bottom, width, 0.3)

func handle_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		State.add_skill.emit(index, skill)