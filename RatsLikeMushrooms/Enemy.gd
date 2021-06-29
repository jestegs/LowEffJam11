extends KinematicBody2D


var player
var speed = 64


func _ready():
	player = Global.player
	add_to_group("enemies")


func _physics_process(delta):
	if player:
		move_and_slide((player.position - position).normalized() * speed)
	else:
		player = Global.player
