extends PathFollow2D

var vel = 100

export var helth = 100

func _ready():
	loop = true
	rotate = false
	rotation = 0

func _process(delta):
	var old_position = position
	offset += delta * vel
	$Sprite.flip_h = (position - old_position).x > 0
	if $Timer.time_left == 0:
		$Sprite.modulate = Color(1,1,1)
	
	if Input.is_action_just_pressed("ui_down"):
		damage(1)

func damage(var damage: float):
	damage -= damage
	$Sprite.modulate = Color(1,0,0)
	$Timer.start()
		