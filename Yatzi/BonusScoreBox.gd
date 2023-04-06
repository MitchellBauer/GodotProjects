extends Control

# Score box properties
var border_color := Color("FF8C00")
var selected_border_color := Color("000000")
var fill_color := Color("FFFFFF")
var border_width := 2

# Label properties
var label_text := ""
var font := FontFile.new()

var selected := false
var written_score := false

func _ready():
	# Set the size of the control
	custom_minimum_size = Vector2(64, 64)
	# Allow the control to receive mouse events
	mouse_filter = MOUSE_FILTER_STOP

func _draw():
	# No Border
	
	# Draw the background
	var background_rect = Rect2(Vector2(border_width, border_width), size - Vector2(border_width * 2, border_width * 2))
	draw_rect(background_rect, fill_color)

	# Draw the text
	var text_position = Vector2(5 , 50)
	draw_string(font, text_position, label_text,HORIZONTAL_ALIGNMENT_CENTER, -1, 50,Color.BLACK,TextServer.JUSTIFICATION_NONE,TextServer.DIRECTION_LTR,TextServer.ORIENTATION_HORIZONTAL)

func bonus_set_score(score: int):
	label_text = str(score)
	selected = false
	written_score = true
	queue_redraw()

func is_written_score() -> bool:
	return written_score
	
func is_selected() -> bool:
	return false
