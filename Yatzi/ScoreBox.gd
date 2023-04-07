class_name ScoreBox
extends Control

# Score box properties
var border_color := Color("38b370")
var selected_border_color := Color("000000")
var fill_color := Color("#F7FFF7")
var border_width := 2

# Label properties
var label_text := ""
var font := FontFile.new()

var selected := false
var written_score := false

signal scorebox_selected(scorebox)
var selected_scorebox: Control = null

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Deselect any previously selected scorebox
			if selected_scorebox:
				selected_scorebox.deselect()
			# Select the current scorebox
			if not written_score:
				selected = not selected
				selected_scorebox = self
				selected_scorebox.select()
				queue_redraw()


func _ready():
	# Set the size of the control
	custom_minimum_size = Vector2(75, 75)
	# Allow the control to receive mouse events
	mouse_filter = MOUSE_FILTER_STOP
	for scorebox in get_tree().get_nodes_in_group("ScoreBox"):
		scorebox.connect("scorebox_selected", Callable(self, "_on_scorebox_selected"))

	
func _draw():
	# Draw the border with the appropriate color based on the selection state
	var current_border_color
	if selected:
		current_border_color = selected_border_color
	else:
		current_border_color = border_color

	if !written_score:
		draw_rounded_rect(Rect2(Vector2.ZERO, size), 10, 10, current_border_color)

	# Draw the background
	var background_rect = Rect2(Vector2(border_width, border_width), size - Vector2(border_width * 2, border_width * 2))
	draw_rounded_rect(background_rect, 10, 10, fill_color)

	# Draw the text
	var text_position = Vector2(5 , 50)
	draw_string(font, text_position, label_text, HORIZONTAL_ALIGNMENT_CENTER, -1, 50, Color.BLACK, TextServer.JUSTIFICATION_NONE, TextServer.DIRECTION_LTR, TextServer.ORIENTATION_HORIZONTAL)

func corner_points(center: Vector2, radius_x: float, radius_y: float, start_angle: float, end_angle: float, point_count: int):
	var points = []
	var angle_step = (end_angle - start_angle) / point_count
	for i in range(point_count + 1):
		var angle = start_angle + angle_step * i
		var point = center + Vector2(cos(angle) * radius_x, sin(angle) * radius_y)
		points.append(point)
	return points

func draw_rounded_rect(rect: Rect2, radius_x: float, radius_y: float, color: Color):
	var point_count = 32

	# Calculate the corner positions
	var top_left = rect.position + Vector2(radius_x, radius_y)
	var top_right = rect.position + Vector2(rect.size.x - radius_x, radius_y)
	var bottom_right = rect.position + rect.size - Vector2(radius_x, radius_y)
	var bottom_left = rect.position + Vector2(radius_x, rect.size.y - radius_y)

	# Construct the rounded rectangle using points
	var rounded_rect_points = []

	# Top-left corner
	rounded_rect_points += corner_points(top_left, radius_x, radius_y, deg_to_rad(180), deg_to_rad(270), point_count)
	# Top-right corner
	rounded_rect_points += corner_points(top_right, radius_x, radius_y, deg_to_rad(270), deg_to_rad(360), point_count)
	# Bottom-right corner
	rounded_rect_points += corner_points(bottom_right, radius_x, radius_y, deg_to_rad(0), deg_to_rad(90), point_count)
	# Bottom-left corner
	rounded_rect_points += corner_points(bottom_left, radius_x, radius_y, deg_to_rad(90), deg_to_rad(180), point_count)

	# Convert the list to PackedVector2Array
	var packed_points = PackedVector2Array(rounded_rect_points)

	# Create a PackedColorArray with the same color for each point
	var colors = PackedColorArray()
	for _i in range(packed_points.size()):
		colors.append(color)

	# Draw the rounded rectangle
	draw_polygon(packed_points, colors)

func set_score(score: int):
	label_text = str(score)
	selected = false
	written_score = true
	queue_redraw()

func is_selected() -> bool:
	return selected
	
func deselect():
	selected = false
	queue_redraw()

func select():
	selected = true
	emit_signal("scorebox_selected", self)
	queue_redraw()
	
func _on_scorebox_selected(scorebox: Control) -> void:
	if scorebox != self:
		deselect()



