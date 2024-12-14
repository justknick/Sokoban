extends Control

class_name Hud

@onready var level_value: Label = $MarginContainer/VBoxContainer/LevelHBox/LevelValue
@onready var moves_value: Label = $MarginContainer/VBoxContainer/MovesHBox/MovesValue
@onready var best_score_value: Label = $MarginContainer/VBoxContainer/BestHBox/BestScoreValue


func set_moves_label(moves: int) -> void: 
	moves_value.text = str(moves)


func new_game(level: String) -> void: 
	var best: int = ScoreSync.get_level_best_score(level)
	
	best_score_value.text = "-" if best == ScoreSync.DEFAULT_SCORE else str(best)
	level_value.text = level
