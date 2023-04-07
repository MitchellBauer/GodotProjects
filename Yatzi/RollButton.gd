extends Button

signal roll_dice

@onready var gameplay = get_node("/root/Gameplay")

func _ready():
	gameplay.decrease_roll_counter()
	emit_signal("roll_dice")

func _on_pressed():
	gameplay.decrease_roll_counter()
	emit_signal("roll_dice")
	set_focus_mode(Control.FOCUS_NONE)

func _on_no_rolls_remaining():
	self.disabled = true

func _on_gameplay_turn_completed(score):
	self.disabled = false
	emit_signal("roll_dice")


func _on_dice_disable_roll_button(par_disabled: bool):
	self.disabled = par_disabled # Replace with function body.
