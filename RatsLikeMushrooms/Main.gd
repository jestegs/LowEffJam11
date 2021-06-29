extends Node2D

#Music by <a href="/users/michaelkobrin-21039285/?tab=audio&amp;utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=audio&amp;utm_content=3783">MichaelKobrin</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=music&amp;utm_content=3783">Pixabay</a>
onready var ui = $UI
onready var ui_in_game = $"UI/In-game"
onready var ui_game_over = $UI/GameOver
onready var world_size = Vector2(64, 64)
onready var world_gen = $WorldMap


func _ready():
	Global.connect("update_mushes", self, "update_scores")
	Global.connect("win", self, "win")
	$RatPlayer/Area2D.connect("body_entered", self, "game_over")
	update_scores(Global.total_mushes, Global.gathered_mushes)
	
	ui_game_over.visible = false
	
	world_gen.gen_world(world_size)


func update_scores(mushes_left, score):
	ui_in_game.get_node("Left").text = "mushrooms left: %s" % mushes_left
	ui_in_game.get_node("Score").text = "mushrooms gathered: %s" % score


func win():
	ui_in_game.visible = false
	ui_game_over.visible = true
	ui_game_over.get_node("YouLose").visible = false
	ui_game_over.get_node("YouWin").visible = true
	


func game_over(body):
	if body.is_in_group("enemies"):
		ui_in_game.visible = false
		ui_game_over.visible = true
		ui_game_over.get_node("YouLose").visible = true
		ui_game_over.get_node("YouWin").visible = false


func _on_Restart_pressed():
	ui_in_game.visible = true
	ui_game_over.visible = false
	
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("mushes", "queue_free")
	Global.total_mushes = 50
	Global.gathered_mushes = 0
	
	world_gen.gen_world(world_size)
	
	Global.player.position = world_gen.map_to_world(Vector2(32, 32))
