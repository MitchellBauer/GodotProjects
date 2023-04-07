extends Node2D

@export var result: int = 1

# Global Variables
var sprite_textures = [
	preload("res://Sprites/diceOne.png"),
	preload("res://Sprites/diceTwo.png"),
	preload("res://Sprites/diceThree.png"),
	preload("res://Sprites/diceFour.png"),
	preload("res://Sprites/diceFive.png"),
	preload("res://Sprites/diceSix.png"),
]

var held: bool = false

signal disable_roll_button


func _ready():
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		held = !held
		_update_visuals()

func _update_visuals():
	if held:
		modulate = Color(0.5, 0.5, 0.5) # Dimmed color
	else:
		modulate = Color(1, 1, 1) # Original color

func on_roll_dice():
	if not held:
		result = randi_range(1, 6)
		$Sprite2D.visible = false
		roll_dice_animation()
		get_node("../AudioStreamPlayer2D").play()
		emit_signal("disable_roll_button", true)  # Pass true to disable the button
		$wait_for_roll.wait_time = 1.5  # set the timer wait time to the desired duration
		$wait_for_roll.start()

func roll_dice_animation():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("Roll")

func _on_animation_finished():
	$AnimatedSprite2D.visible = false
	emit_signal("disable_roll_button", false)  # Pass false to enable the button
	display_result(result)

func display_result(result: int):
	var sprite_texture = sprite_textures[result - 1]
	$Sprite2D.texture = sprite_texture
	$Sprite2D.visible = true
	

