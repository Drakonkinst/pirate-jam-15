extends Node2D


@export var move_speed = 50.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	walk(delta)
	

func walk(delta):
	global_position += Vector2(-move_speed * delta,0)
