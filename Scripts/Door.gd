extends StaticBody2D

func _ready():
	pass
	
func _process(delta):
	var player = get_tree().get_root().find_node("NinjaAvocado", true, false)
	if player != null:
		if player.get("avocados_rescued") >= 2:
			$Sprite.visible = false
			$CollisionPolygon2D.disabled = true
