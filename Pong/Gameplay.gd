extends Node2D

@onready var ball = $Ball

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/EnemyScore.text = str(0)
	$Control/PlayerScore.text = str(0)


# Initialize the scores for each player
var player1_score = 0
var player2_score = 0

# Called when a player scores
func _player_scored(player):
	# Increase the score for the opposite player
	if player == 1:
		player2_score += 1
		$Control/EnemyScore.text = str(player2_score)
	else:
		player1_score += 1
		$Control/PlayerScore.text = str(player1_score)

# Called when the ball goes off screen
func _right_goal_area_entered(body):
		# Player 1 scores
		print("Player 1 Scores!")
		_player_scored(1)
		_reset_ball()
		
func _left_goal_area_entered(body):
		# Player 2 scores
		print("Enemy Scores!")
		_player_scored(2)
		_reset_ball()
		
func _reset_ball():
	# Reposition the ball and reset its velocity
	var viewport_size = get_viewport_rect().size
	var middle_point = viewport_size / 2
	ball._reset_ball_velocity()
	ball.position = middle_point
