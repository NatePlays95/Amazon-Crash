extends BossState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func enter(_msg := {}):
	boss.anim_player.play("dead")

func animation_finished(anim_name):
	if anim_name == "dead":
		boss.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
