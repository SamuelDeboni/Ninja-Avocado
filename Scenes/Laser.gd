extends Area2D

var vel = 0
var t = 0.0

func _process(delta):
	t += delta
	
	if t > 5:
		queue_free()
		
	move_local_x(vel*delta)



func _on_Laser_body_entered(body):
	if body.name == "NinjaAvocado":
		body.damage(10)
		queue_free()
