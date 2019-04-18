extends KinematicBody2D

var vel = Vector2()

var t = 0.0

func _ready():
	position = Vector2(20,20)

func _process(delta):
	t += delta
	
	if t > 5:
		queue_free()
		
	move_and_collide(vel,true)
	rotate(delta*20)