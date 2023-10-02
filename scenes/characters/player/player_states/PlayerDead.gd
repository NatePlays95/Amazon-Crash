extends PlayerState



func enter(_msg := {}) -> void:
	# owner é o Player (em uma cena salva, owner é o node raiz)
	owner.velocity = Vector2.ZERO
	player.anim_player.stop()
	var timer = get_tree().create_timer(2)
	timer.connect("timeout", self, "on_timer_expired")


func on_timer_expired():
	DebugAutoload.goto_title()

#func update(_dt) -> void:
#	if Input.is_action_just_pressed("attack_1"):
#		state_machine.transition_to("Attack1")
#	
#	if Input.get_axis("move_up","move_down") != 0  or Input.get_axis("move_left","move_right") != 0:
#		state_machine.transition_to("Move")
