extends Node


signal update_mushes(mushes_left, score)
signal win


var mushes = [
	preload("res://textures/mush_brown.png"),
	preload("res://textures/mush_purple.png"),
	preload("res://textures/mush_green.png")
]

onready var total_mushes = 50
var gathered_mushes = 0
var player


func update_mushes():
	gathered_mushes += 1
	total_mushes -= 1
	emit_signal("update_mushes", total_mushes, gathered_mushes)
	$Eat.play()
	
	if total_mushes == 0:
		emit_signal("win")
