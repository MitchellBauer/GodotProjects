extends Button

@onready var gameplay = get_node("/root/Gameplay")

func _ready():
	self.disabled = true
	set_focus_mode(FOCUS_NONE)

func _on_no_rolls_remaining():
	self.disabled = false

func _on_turn_completed(score):
	# Update the score sheet UI with the score for the completed turn
	self.disabled = true


func _on_pressed():
	# Check if any ScoreBox is selected
	var scoreboxes = get_tree().get_nodes_in_group("ScoreBox")
	var any_scorebox_selected = false
	var has_yahtzee = gameplay.check_for_yahtzee()  # Add this function in your gameplay script
	
	for scorebox in scoreboxes:
		if scorebox.is_selected():
			any_scorebox_selected = true
			break
		elif scorebox.get_name() == "YahtzeeScoreBox" and has_yahtzee:
			var score = gameplay.calculate_score_for_turn()
			gameplay.end_turn(score)
			break
	
	# Continue only if a ScoreBox is selected or there's a Yahtzee in hand
	if any_scorebox_selected:
		# Calculate the score for the current turn
		var score = gameplay.calculate_score_for_turn()
		gameplay.end_turn(score)
	else:
		# Show a warning dialog
		var warning_dialog = get_node("../../NoSelectionWarningDialog")
		warning_dialog.popup_centered()
