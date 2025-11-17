extends Control

class_name InteractibleLabel

@export var text: String = "Label"

@export var padding_v := 10
@export var padding_h := 10
@export var radius := 10

@onready var panel := $Panel
@onready var label := $Panel/Label

signal click_event()

func _ready() -> void:
	panel.size = label.get_rect().size + Vector2(padding_h * 2, padding_v * 2)
	panel.position -= panel.size / 2
	panel.radius = radius
	
	label.text = text
	
	$Panel.click_event.connect(click_event.emit)
		
