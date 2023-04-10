extends Node2D

signal play_again

func _ready():
	# Display the user's score, e.g., by setting the text of a Label node
	$ScoreLabel.text = str(GameData.get_score())
	update_high_scores(GameData.get_score())
	update_high_score_labels()
	# Display the user's score, e.g., by setting the text of a Label node

func update_high_scores(new_score):
	var high_scores = load_high_scores()
	high_scores.append(new_score)
	high_scores.sort() # Sort in ascending order
	high_scores.resize(10) # Keep only the top 10 scores
	save_high_scores(high_scores)

func update_high_score_labels():
	var high_scores = load_high_scores()
	for i in range(len(high_scores)):
		var score = high_scores[len(high_scores) - 1 - i] # Access scores in reverse order
		var label = $HighScoresContainer.get_node("HighScoreLabel" + str(i))
		label.text = "High Score %d: %d" % [i + 1, score]

func load_high_scores():
	var high_scores = []
	var config = ConfigFile.new()
	var err = config.load("user://high_scores.cfg")

	if err == OK:
		for i in range(10):
			var score = config.get_value("high_scores", str(i), -1)
			if score != -1:
				high_scores.append(score)
	else:
		print("Error loading high_scores.cfg")

	return high_scores

func save_high_scores(high_scores):
	var config = ConfigFile.new()

	for i in range(len(high_scores)):
		config.set_value("high_scores", str(i), high_scores[i])

	var err = config.save("user://high_scores.cfg")
	if err != OK:
		print("Error saving high_scores.cfg")

func _on_button_pressed():
	emit_signal("play_again")
