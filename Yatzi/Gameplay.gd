extends Node2D

var rolls_remaining = 3
var turn = 1
var max_turns = 13
var current_score = 0
var One_Time_Bonus:= false
var number_scores_flag_for_bonus = 0

signal no_rolls_remaining
signal turn_completed(score)

func reset_roll_counter():
	rolls_remaining = 2
	$TopLabels/Rolls.text = str(rolls_remaining)

func decrease_roll_counter():
	rolls_remaining -= 1
	$TopLabels/Rolls.text = str(rolls_remaining)
	if rolls_remaining <= 0:
		emit_signal("no_rolls_remaining")

func end_turn(score):
	turn += 1
	$TopLabels/Turn.text = str(turn)
	$TopLabels/Score.text =  str(current_score)
	reset_roll_counter()
	if turn > max_turns:
		pass #TODO End the game
	else:
		reset_dice_held_state()
		emit_signal("turn_completed", score)
		
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
	var yahtzee_score = calculate_yahtzee_score(dice_results)
	if yahtzee_score > 0:
		var yahtzee_score_box = get_node("MajorContainer/YahtzeeScoreBox")
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
		"FiceScoreBox",
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



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

