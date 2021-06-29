extends KinematicBody2D


onready var anim_player = $AnimatedSprite
var move_direction
var speed = 128 # pixel speed


func _ready():
	Global.player = self
	add_to_group("players")
	position = Vector2(32, 32) * 32


func _physics_process(_delta):
	# player input
	move_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	
	# animations
	if move_direction:
		anim_player.play("rat_run_side")
		if move_direction.x > 0:
			anim_player.flip_h = true
		elif move_direction.x < 0:
			anim_player.flip_h = false
	else:
		anim_player.play("rat_idle")
	
	move_and_slide(move_direction * speed)
