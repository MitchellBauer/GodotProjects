extends Button

signal roll_dice

@onready var gameplay = get_node("/root/Gameplay")

# Called when the node enters the scene tree for the first time.
func _ready():
	gameplay.decrease_roll_counter()
	emit_signal("roll_dice")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	# Emit the roll_dice signal
	gameplay.decrease_roll_counter()
	emit_signal("roll_dice")

func _on_no_rolls_remaining():
	self.disabled = true


func _on_gameplay_turn_completed(score):
	self.disabled = false
	emit_signal("roll_dice")
