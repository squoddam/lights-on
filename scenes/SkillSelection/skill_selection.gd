extends Control

@onready var skills_container: Control = $SkillsContainer
@onready var skills_list: Control = $SkillsContainer/VBoxContainer

@onready var background: Control = $Background

@onready var SkillCardScene: PackedScene = load("res://scenes/SkillSelection/SkillCard.tscn")

var card_shift: int = 128

func _ready() -> void:
	background.open_animation_start.connect(func() -> void: top_level = true)
	#background.animation_end.connect(show_skills)
	background.close_animation_end.connect(func() -> void: top_level = false)

func show_skills() -> void:
	var skills := State.get_rand_skills(3)
	var skill_cards: Array[SkillCard] = []
	
	for skill_index:int in skills.size():
		var skill := skills[skill_index]
		var skill_card: SkillCard = SkillCardScene.instantiate()
		
		skill_cards.append(skill_card)
		skills_list.add_child(skill_card)
		
		skill_card.init(skill, ("%s%s" % ["+" if skill.change > 0 else "-", abs(skill.change)]) + "%", skill_index)
		
	skills_container.modulate.a = 0.
		
	var t := create_tween()
	
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(skills_container, "position", skills_container.position, .5).from(skills_container.position + Vector2(0, card_shift))
	t.parallel().tween_property(skills_container, "modulate:a", 1., .3).set_delay(.2)
