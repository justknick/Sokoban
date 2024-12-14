extends Control

class_name GameOverUI

@onready var moves_label: Label = $MarginContainer/NinePatchRect/VBoxContainer/MovesLabel
@onready var record_label: Label = $MarginContainer/NinePatchRect/VBoxContainer/RecordLabel


func _ready() -> void: 
	pass 


func new_game() -> void: 
	record_label.hide()
	hide()


func game_over(level: String, moves: int) -> void: 
	moves_label.text = "%d moves taken!" % moves
	record_label.visible = ScoreSync.score_is_new_best(level, moves)
	print("show new record? ", ScoreSync.score_is_new_best(level, moves))
	show()
	
