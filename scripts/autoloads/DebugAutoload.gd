extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func goto_title():
	get_tree().change_scene("res://scenes/TitleScene.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _unhandled_key_input(event):
	pass
	#if Input.is_key_pressed(KEY_1):
	#	var scene = load("res://scenes/characters/bosses/boss1/Boss1.tscn")
	#	get_tree().current_scene.add_child(scene.instance())
