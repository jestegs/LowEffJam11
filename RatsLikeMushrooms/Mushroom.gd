extends Sprite


func _ready():
	add_to_group("mushes")
	texture = Global.mushes[randi() % 3]


func _on_Area2D_body_entered(body):
	if body.is_in_group("players"):
		Global.update_mushes()
		queue_free()
