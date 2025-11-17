extends Control

class_name SkillIcon

@onready var multiplier_icon: Control = $MultiplierIcon
@onready var direction_icon: DirectionIcon = $DirectionIcon

func init(skill: Dictionary) -> void:
	match skill.type:
		Skills.SkillType.Multiplier: multiplier_icon.visible = true
		Skills.SkillType.Direction: 
			direction_icon.visible = true
			direction_icon.init(skill.directions_amount)
