extends Area2D

var is_rescued = false

func _on_Avocado_body_entered(body):
	if body.name == "NinjaAvocado":
		body.checkpoint_pos = position
		body.health = 100
		body.nacho_count = 50
		if not is_rescued:
			body.avocados_rescued += 1
		is_rescued = true
		
