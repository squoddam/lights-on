extends Control

class_name GameOverScreen

@onready var round_label: Label = $VBoxContainer/HBoxContainer/Round
@onready var score_label: Label = $VBoxContainer/HBoxContainer/Score

#@onready var restart_button: InteractibleLabel = $VBoxContainer/InteractibleLabel
@onready var restart_button: Label = $VBoxContainer/Restart

signal restart_clicked()

func _ready() -> void:
	#restart_button.click_event.connect(func() -> void: restart_clicked.emit())
	restart_button.gui_input.connect(handle_restart_gui_input)

func set_stats(round_num: int, score: int) -> void:
	round_label.text = "Round: " + str(round_num)
	score_label.text = "Score: " + str(score)

func handle_restart_gui_input(event: InputEvent) -> void: 
	if event.is_pressed(): 
		restart_clicked.emit()
