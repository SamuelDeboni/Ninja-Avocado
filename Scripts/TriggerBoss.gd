extends Area2D

func _ready():
	pass



func _process(delta):
	pass


func _on_TriggerBoss_body_entered(body):
	if body.name == "NinjaAvocado":
		get_tree().get_root().find_node("Boss", true, false).activate()
