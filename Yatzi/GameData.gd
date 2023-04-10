extends Node

var user_score = 0
var rolls_remaining = 3
var turn = 1
var max_turns = 13

func set_score(score):
	user_score = score

func get_score():
	return user_score

func is_there_rolls_remaining():
	if GameData.rolls_remaining <= 0:
		print("Roll remaining: " + str(rolls_remaining) + " returning " + str(false))
		return false
	else:
		print("Roll remaining: " + str(rolls_remaining) + " returning " + str(true))
		return true
