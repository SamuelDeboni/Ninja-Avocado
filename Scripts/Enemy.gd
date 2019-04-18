extends PathFollow2D

var vel = 100

func _ready():
	loop = true
	rotate = false
	rotation = 0

func _process(delta):
	var old_position = position
	offset += delta * vel
	
	$Sprite.flip_h = (position - old_position).x > 0
	
