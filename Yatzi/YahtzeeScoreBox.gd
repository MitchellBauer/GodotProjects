extends ScoreBox

# BonusScoreBox specific properties
var total_yahtzee_score := 0
var yahtzee_count := 0

func is_yahtzee(dice_values: Array) -> bool:
	var first_value = dice_values[0]
	for value in dice_values:
		if value != first_value:
			return false
	return true

func new_yahtzee_score(dice_values: Array):
	if get_name() == "YahtzeeScoreBox" and yahtzee_count < 3 and is_yahtzee(dice_values):
		yahtzee_count += 1
		var yahtzee_score = 50
		if written_score:
			# If a score has already been written to the YahtzeeScoreBox,
			# add the additional 50 points to the previous score
			yahtzee_score += total_yahtzee_score
		total_yahtzee_score += yahtzee_score
		label_text = str(yahtzee_score)
		written_score = true
		deselect()
		queue_redraw()

func _on_scorebox_selected(scorebox: Control) -> void:
	if scorebox != self:
		deselect()
