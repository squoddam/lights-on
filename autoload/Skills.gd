extends Node

enum SkillType {
	Multiplier,
	Direction
}

var direction_skills: Array[Dictionary] = [
	{
		"type": SkillType.Direction,
		"directions_amount": 0,
		"tiers": [-20, -10, -5]
	},
	{
		"type": SkillType.Direction,
		"directions_amount": 1,
		"tiers": [-20, -10, -5]
	},
	{
		"type": SkillType.Direction,
		"directions_amount": 2,
		"tiers": [10, 20, 30]
	},
	{
		"type": SkillType.Direction,
		"directions_amount": 3,
		"tiers": [5, 10, 15]
	},
	{
		"type": SkillType.Direction,
		"directions_amount": 4,
		"tiers": [5, 10, 15]
	}
]

var multiplier_skills: Array[Dictionary] = [
	{
		"type": SkillType.Multiplier,
		"multiply_by": 2,
		"tiers": [2, 5, 7]
	}
]

var all_skills: Array[Dictionary] = []

func _ready() -> void:
	all_skills.append_array(direction_skills)
	all_skills.append_array(multiplier_skills)
