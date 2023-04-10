extends Button

@onready var gameplay = get_node("/root/Gameplay")

func _ready():
	self.disabled = true
	set_focus_mode(FOCUS_NONE)

func _on_no_rolls_remaining():
	self.disabled = false

func _on_turn_completed():
	self.disabled = true

func _on_pressed():
	var scoreboxes = get_tree().get_nodes_in_group("ScoreBox")
	var any_scorebox_selected = false
	var yahtzee_scorebox = null
	var has_yahtzee = gameplay.check_for_yahtzee()  # Add this function in your gameplay script

	for scorebox in scoreboxes:
		if scorebox.is_selected():
			any_scorebox_selected = true
			break
		elif scorebox.get_name() == "YahtzeeScoreBox":
			yahtzee_scorebox = scorebox

	if has_yahtzee and yahtzee_scorebox and !yahtzee_scorebox.is_written_score():
		yahtzee_scorebox.new_yahtzee_score(gameplay.get_dice_values())  # Assuming there's a function in the gameplay node to get dice values
		any_scorebox_selected = true

	if any_scorebox_selected:
		gameplay.end_turn()
	else:
		var warning_dialog = get_node("../../NoSelectionWarningDialog")
		warning_dialog.popup_centered()
