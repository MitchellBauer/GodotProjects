extends Button

signal roll_dice

@onready var gameplay = get_node("/root/Gameplay")

func _ready():
	gameplay.decrease_roll_counter()
	emit_signal("roll_dice")
	# gameplay.connect("no_rolls_remaining", Callable(self, "_on_no_rolls_remaining"))

func _on_pressed():
	gameplay.decrease_roll_counter()
	emit_signal("roll_dice")
	set_focus_mode(Control.FOCUS_NONE)

func _on_no_rolls_remaining():
	disable_roll_button()

func _on_gameplay_turn_completed():
	enable_roll_button()
	emit_signal("roll_dice")

func disable_roll_button():
	print_stack()
	self.disabled = true
	
func enable_roll_button():
	print_stack()
	if GameData.rolls_remaining > 0:
		self.disabled = false
