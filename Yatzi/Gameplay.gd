extends Node2D

var current_score : int = GameData.get_score()
var One_Time_Bonus:= false
var number_scores_flag_for_bonus = 0

signal no_rolls_remaining
signal turn_completed()

func reset_roll_counter():
	GameData.rolls_remaining = 2
	$TopLabels/Rolls.text = str(GameData.rolls_remaining)

func decrease_roll_counter():
	GameData.rolls_remaining -= 1
	$TopLabels/Rolls.text = str(GameData.rolls_remaining)
	if GameData.is_there_rolls_remaining():
		emit_signal("no_rolls_remaining")

func end_turn():
	GameData.turn += 1
	$TopLabels/Turn.text = str(GameData.turn)
	current_score = calculate_score_for_turn()
	GameData.set_score(current_score)  # Update the score in the GameData singleton
	$TopLabels/Score.text =  str(current_score)
	reset_roll_counter()
	if GameData.turn > GameData.max_turns:
		change_scene("res://EndGameScene.tscn")
	else:
		reset_dice_held_state()
		emit_signal("turn_completed")
		
		
func change_scene(new_scene_path):
	var new_scene = load(new_scene_path).instance()
	get_tree().root.add_child(new_scene)
	get_tree().root.remove_child(get_tree().get_current_scene())
	get_tree().set_current_scene(new_scene)
	
	if new_scene_path == "res://GameplayScene.tscn":
		new_scene.connect("play_again", Callable(self, "reset_game_and_start_again"))
		
func reset_game_and_start_again():
	reset_game()
	change_scene("res://GameplayScene.tscn")
		
func calculate_score_for_turn():
	var scoreboxes = get_tree().get_nodes_in_group("ScoreBox")
	var dice = get_tree().get_nodes_in_group("Dice")
	var dice_results = []
	var new_score = 0
	
	var number_score_boxes = {
		"OnesScoreBox": 1,
		"TwosScoreBox": 2,
		"ThreeScoreBox": 3,
		"FourScoreBox": 4,
		"FiveScoreBox": 5,
		"SixScoreBox": 6
	}

	for die in dice:
		dice_results.append(die.result)
		
	# Check if the player has a Yahtzee
	var yahtzee_score_box = get_node("MajorContainer/YahtzeeScoreBox")
	if yahtzee_score_box.is_selected():
		var yahtzee_score = calculate_yahtzee_score(dice_results)
		if yahtzee_score > 0:
			yahtzee_score_box.new_yahtzee_score()
			new_score = yahtzee_score
	else:
		for scorebox in scoreboxes:
			if scorebox.is_selected():
				print("Selected scorebox: ", scorebox.get_name())

				var scorebox_name = scorebox.get_name()
				if scorebox_name in number_score_boxes:
					var number = number_score_boxes[scorebox_name]
					var filtered_dice = []
					for x in dice_results:
						if x == number:
							filtered_dice.append(x)
					new_score = calculate_sum(filtered_dice)
					scorebox.set_score(new_score)

				else:
					match scorebox_name:
						"ThreeOfAKindScoreBox":
							new_score = calculate_three_or_four_of_a_kind_score(dice_results, 3)
							scorebox.set_score(new_score)
						"FourOfAKindScoreBox":
							new_score = calculate_three_or_four_of_a_kind_score(dice_results, 4)
							scorebox.set_score(new_score)
						"FullHouseScoreBox":
							new_score = calculate_full_house_score(dice_results)
							scorebox.set_score(new_score)
						"SmallStraightScoreBox":
							new_score = calculate_small_straight_score(dice_results)
							scorebox.set_score(new_score)
						"LargeStraightScoreBox":
							new_score = calculate_large_straight_score(dice_results)
							scorebox.set_score(new_score)
						"ChanceScoreBox":
							new_score = calculate_sum(dice_results)
							scorebox.set_score(new_score)
				
				
		# Check for bonus
		if !One_Time_Bonus and number_scores_flag_for_bonus == 6:
			if check_number_score_boxes_bonus():
				$MinorContainer/HBoxContainer7/BonusScoreBox.set_score(35)
				new_score += 35
	
	current_score += new_score
	return current_score

func calculate_three_or_four_of_a_kind_score(dice_results, count):
	var counts = count_dice_results(dice_results)
	for value in counts.values():
		if value >= count:
			return calculate_sum(dice_results)
	print("Warning: No", count, "of a kind found.")
	return 0

func calculate_full_house_score(dice_results):
	var counts = count_dice_results(dice_results)
	var has_two = false
	var has_three = false
	for value in counts.values():
		if value == 2:
			has_two = true
		elif value == 3:
			has_three = true
	if has_two and has_three:
		return calculate_sum(dice_results)
	print("Warning: No Full House found.")
	return 0

func calculate_small_straight_score(dice_results: Array) -> int:
	var unique_dice = unique_sorted(dice_results)
	var straights = [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]]
	for straight in straights:
		if is_subset(straight, unique_dice):
			return 30
	print("Warning: No Small Straight found.")
	return 0


func unique_sorted(arr: Array) -> Array:
	var unique_array = []
	for item in arr:
		if not unique_array.has(item):
			unique_array.append(item)
	unique_array.sort()
	return unique_array

func calculate_large_straight_score(dice_results: Array) -> int:
	var unique_dice = unique_sorted(dice_results)
	var straight = [1, 2, 3, 4, 5, 6]
	if unique_dice == straight:
		return 40
	print("Warning: No Large Straight found.")
	return 0


func calculate_yahtzee_score(dice_results: Array) -> int:
	var counts = {}
	for die in dice_results:
		if die in counts:
			counts[die] += 1
		else:
			counts[die] = 1

	for count in counts.values():
		if count == 5:
			return 50

	print("Warning: No Yahtzee found.")
	return 0

func count_dice_results(dice_results):
	var counts = {}
	for result in dice_results:
		counts[result] = counts.get(result, 0) + 1
	return counts
	
func is_subset(arr1, arr2):
	for item in arr1:
		if item not in arr2:
			return false
	return true
	
func calculate_sum(array):
	var total = 0
	for element in array:
		total += element
	return total
	
func reset_dice_held_state():
	var dice_nodes = get_tree().get_nodes_in_group("Dice")
	for die in dice_nodes:
		die.held = false
		die._update_visuals()
		
func check_number_score_boxes_bonus():
	var score_boxes = [
		"OnesScoreBox",
		"TwosScoreBox",
		"ThreeScoreBox",
		"FourScoreBox",
		"FiveScoreBox",
		"SixScoreBox"
	]
	var total_score = 0
	
	for box_name in score_boxes:
		var score_box = get_node(box_name)
		if not score_box.written_score:
			return false
		total_score += score_box.current_score
	
	return total_score > 63
	
func check_for_yahtzee():
	var dice = get_tree().get_nodes_in_group("Dice")
	var dice_results = []
	
	for die in dice:
		dice_results.append(die.result)
	
	var count_per_value = {}
	for result in dice_results:
		if result in count_per_value:
			count_per_value[result] += 1
		else:
			count_per_value[result] = 1
	
	for count in count_per_value.values():
		if count == 5:
			return true
	
	return false
	
func reset_game():
	GameData.rolls_remaining = 3
	GameData.turn = 1
	GameData.max_turns = 13
	current_score = 0
	GameData.set_score(current_score)
	$TopLabels/Score.text = str(current_score)
	$TopLabels/Turn.text = str(GameData.turn)
	$TopLabels/Rolls.text = str(GameData.rolls_remaining)
	One_Time_Bonus = false
	number_scores_flag_for_bonus = 0
	reset_dice_held_state()

	# Reset all the score boxes
	var scoreboxes = get_tree().get_nodes_in_group("ScoreBox")
	for scorebox in scoreboxes:
		scorebox.reset_score()

func get_dice_results():
	var dice = get_tree().get_nodes_in_group("Dice")
	var dice_results = []
	for die in dice:
		dice_results.append(die.result)
	return dice_results
	

