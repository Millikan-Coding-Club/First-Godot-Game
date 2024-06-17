extends Camera2D

@onready var ball = $"../Ball"
@onready var max_height = ball.position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ball_y = ball.position.y
	if ball_y > position.y + 330:
		pass # fell off
		
	if ball_y < max_height:
		max_height = ball_y
	position.y = max_height
