extends Node


@onready var obstacle_scn = preload("res://scenes/Obstacle.tscn").instantiate()
@onready var score_label = $"../ScoreLabel"
@onready var ball = $"../SubViewportContainer/SubViewport/Ball"
@onready var height = ball.position.y - 1000
@export var difficulty_speed: float = 100:
	get:
		return difficulty_speed / 10000
@export var obstacle_min_dist = 500:
	get:
		return max(obstacle_min_dist - score * difficulty_speed, 128)
@export var obstacle_max_dist = 1500:
	get:
		return max(obstacle_max_dist - score * difficulty_speed, 500)
var game_over = false
var spawn_dist = 1000
var wrap_limit = 430
var score = 0:
	set(value):
		score = maxi(value, score) # Keep highest score
		
func _process(delta):
	# Update score
	score = -roundi(ball.position.y)
	score_label.text = str(score)
	
	# Spawn obstacles
	if ball.position.y <= height + spawn_dist:
		var obstacle = obstacle_scn.duplicate()
		obstacle.position = Vector2(0, height)
		$"../SubViewportContainer/SubViewport".add_child(obstacle)
		var animator = obstacle.find_child("AnimationPlayer")
		animator.seek(randf() * 4)
		height -= randf_range(obstacle_min_dist, obstacle_max_dist)


func _game_over():
	game_over = true
	$"../GameOverLabel".visible = true
	#get_tree().reload_current_scene()
