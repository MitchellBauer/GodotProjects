extends CharacterBody2D

@export var player_movement_speed = 500
@export var player_movement_acceleration = 300
var player_speed = Vector2.ZERO

func _physics_process(delta):
	player_input(delta)
	
	var collision = move_and_collide(player_speed * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.get_class().get_basename() == "StaticBody2D":
			player_speed = (player_speed.bounce(collision.get_normal()))/7
		else:
			player_speed = Vector2.ZERO

	

func player_input(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("w"):
		direction.y -= 1
	if Input.is_action_pressed("s"):
		direction.y += 1
	
	# Gradually change the player's movement speed based on input direction
	player_speed += direction.normalized() * delta * player_movement_acceleration
	player_speed = player_speed.clamp(Vector2(-player_movement_speed, -player_movement_speed), Vector2(player_movement_speed, player_movement_speed))
