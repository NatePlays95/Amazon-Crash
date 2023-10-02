class_name Projectile
extends Node2D


#export var DESTROY_ON_COLLISION = false #requires Area2D named SolidCollisionArea2D
export var DESTROY_ON_ANIM_END = false #doesn't work with looping anims


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#try to find anim_player node
	var anim_player = get_node_or_null("AnimationPlayer")
	if anim_player != null:
		anim_player.connect("animation_finished", self, "_on_animation_finished")
		anim_player.play("default")


# feel free to override this with custom logic
func _on_animation_finished(anim_name):
	if DESTROY_ON_ANIM_END:
		destroy()

func destroy():
	queue_free()
