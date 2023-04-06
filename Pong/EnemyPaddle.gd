extends CharacterBody2D

@onready var ball = get_node("/root/Gameplay/Ball")
@onready var enemy_paddle = get_node("/root/Gameplay/EnemyPaddle")
@export var enemy_paddle_speed = 30
var player_speed = 0
var enemy_timer = 0.0

func _physics_process(delta):
	#increment the timer
	enemy_timer += delta
	
	if enemy_timer >= 0.05:
		_move_enemy(delta)
		enemy_timer = 0.0

func _move_enemy(delta):
	var ball_position = ball.position
	var enemy_position = enemy_paddle.position
	# Calculate the distance to move
	var distance = abs(ball_position.y - enemy_position.y) / 10

	# Update the y velocity of the enemy paddle
	enemy_paddle.velocity.y = sign(ball_position.y - enemy_position.y) * distance * delta * enemy_paddle_speed
	move_and_collide(enemy_paddle.velocity)
