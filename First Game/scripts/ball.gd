extends RigidBody2D


@export var force = 5
@export var max_line_length = 300
const wrap_limit = 430
var dragging
var added_child

var line = Line2D.new()
var line_vector = Vector2()
var gradient = Gradient.new()
var curve = Curve.new()

func _ready():
	# Curve
	curve.add_point(Vector2(0, 2.5))
	curve.add_point(Vector2(1, 1))
	# Gradient
	gradient.set_color(0, Color.RED)
	gradient.set_color(1, Color.YELLOW)
	# Line
	line.z_index = -1
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	#line.gradient = gradient
	line.width_curve = curve

func _process(delta):
	if Input.is_action_pressed("click"):
		line_vector = (get_global_mouse_position() - global_position).normalized() \
				* minf((get_global_mouse_position() - global_position).length(), max_line_length)
		line.default_color = gradient.sample(1 - line_vector.length() / max_line_length)
		line.global_position = global_position
		line.set_point_position(1, line_vector)

func _input(event):
	if event.is_action_pressed("click") and not dragging:
		if !added_child:
			added_child = true
			$"..".add_child((line))
		line.add_point(Vector2())
		line.add_point(Vector2(), 1)
		dragging = true
		Engine.time_scale = 0.25
		
	if event.is_action_released("click") and dragging:
		line.clear_points()
		linear_velocity = line_vector * force
		dragging = false
		Engine.time_scale = 1
		
func _integrate_forces(state):
	if position.x < wrap_limit * -1:
		position.x = wrap_limit
	if position.x > wrap_limit:
		position.x = wrap_limit * -1
