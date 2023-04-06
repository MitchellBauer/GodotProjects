extends CharacterBody2D

const SPEED = 300
var angle = randf_range(-PI/4, PI/4)
var prev_angle = 0

func _ready():
	randomize()
	_randomize_angle()
	velocity = Vector2(SPEED * cos(angle), SPEED * sin(angle))

func _reset_ball_velocity():
	_randomize_angle()
	var direction = 1 if randf_range(0, 1) > 0.5 else -1
	velocity = Vector2(SPEED * cos(angle), SPEED * sin(angle)) * direction

func _randomize_angle():
	prev_angle = angle
	if prev_angle != angle:
		while abs(angle) < PI/8:
			angle = randf_range(-PI/4, PI/4)
	else:
		angle = randf_range(-PI/4, PI/4)

func _physics_process(delta):
	velocity = velocity.normalized() * SPEED 
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()
