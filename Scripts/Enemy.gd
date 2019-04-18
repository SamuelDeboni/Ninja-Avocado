extends PathFollow2D

var vel = 100

export var helth = 20
export var damage_color = Color()

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
		vel = 100

func die():
	queue_free()

func damage(var damage: float):
	helth -= damage
	vel = 0
	$Sprite.modulate = damage_color
	$Timer.start()
	if helth <= 0:
		die()
	print(helth)
		

func _on_Area2D_body_entered(body):
	if body.name != "NinjaAvocado":
		damage(5)
		body.queue_free()
