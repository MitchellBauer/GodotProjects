extends Node2D

@export var result: int = 1

#Global Variables
var sprite_textures = [
	preload("res://Sprites/1.png"),
	preload("res://Sprites/2.png"),
	preload("res://Sprites/3.png"),
	preload("res://Sprites/4.png"),
	preload("res://Sprites/5.png"),
	preload("res://Sprites/6.png"),
]

const SPRITE_BASE_PATH = "res://Sprites/"
var held: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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
		# Roll the dice
		result = randi_range(1, 6)
		display_result(result)
		
func display_result(result: int):
	# Get the sprite texture for the rolled result
	var sprite_texture = sprite_textures[result - 1]
	
	# Set the texture of the Sprite2D node to the rolled result
	$Sprite2D.texture = sprite_texture
