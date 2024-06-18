extends RigidBody2D

@onready var game_manager = $"../../../Game Manager"
@export var force = 5
@export var max_line_length = 300
const wrap_limit = 430

@onready var line = $Line2D
@export var gradient : Gradient
var line_vector := Vector2()

func _process(delta):
	if Input.is_action_pressed("click") and not game_manager.game_over:
		# Update line based on mouse position
		line_vector = (get_global_mouse_position() - global_position).normalized() \
				* minf((get_global_mouse_position() - global_position).length(), max_line_length)
		line.default_color = gradient.sample(1 - line_vector.length() / max_line_length)
		line.global_position = global_position
		line.set_point_position(1, line_vector)

func _input(event):
	if event.is_action_pressed("click"):
		line.add_point(Vector2())
		line.add_point(Vector2(), 1)
		Engine.time_scale = 0.25
		
	if event.is_action_released("click"):
		line.clear_points()
		linear_velocity = line_vector * force
		Engine.time_scale = 1
		
func _integrate_forces(state):
	var transform = state.transform.get_origin()
	if transform.x < wrap_limit * -1:
		transform.x = wrap_limit
	if transform.x > wrap_limit:
		transform.x = wrap_limit * -1
	state.transform.origin = transform
