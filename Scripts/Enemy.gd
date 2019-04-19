extends PathFollow2D

var vel = 100

export var health = 20
export var damage_color = Color()

onready var laser = preload("res://Scenes/Laser.tscn")

func _ready():
	loop = true
	rotate = false
	rotation = 0
	$LaserTimer.connect("timeout", self, "attack")

func _process(delta):
	var old_position = position
	offset += delta * vel
	$Sprite.flip_h = (position - old_position).x > 0
	if $Timer.time_left == 0:
		$Sprite.modulate = Color(1,1,1)
		vel = 100

func die():
	queue_free()

func attack():
	var laseri = laser.instance()
	get_node("..").add_child(laseri)
	laseri.position = position + Vector2(0, -7)
	laseri.vel = Vector2(500, 0) if $Sprite.flip_h else Vector2(-500, 0)
	
func damage(var damage: float):
	health -= damage
	vel = 0
	$Sprite.modulate = damage_color
	$Timer.start()
	if health <= 0:
		die()
	print(health)

func _on_Area2D_body_entered(body):
	if body.name != "NinjaAvocado":
		damage(5)
		body.queue_free()
