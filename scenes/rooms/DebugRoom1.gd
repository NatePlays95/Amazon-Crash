extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var boss_timer = get_tree().create_timer(3)
	boss_timer.connect("timeout", self, "on_boss_timer_timeout")


func on_boss_timer_timeout():
	var boss = load("res://scenes/characters/bosses/boss1/Boss1.tscn")
	get_tree().current_scene.get_node("Characters").add_child(boss.instance())

