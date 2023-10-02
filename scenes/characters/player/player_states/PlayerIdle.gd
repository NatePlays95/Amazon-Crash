
extends PlayerState



func enter(_msg := {}) -> void:
	# owner é o Player (em uma cena salva, owner é o node raiz)
	#owner.velocity = Vector2.ZERO
	player.anim_player.stop()
	#player.anim_player.play("idle")
	pass

func update(_dt) -> void:
	if Input.get_axis("move_up","move_down") != 0  or Input.get_axis("move_left","move_right") != 0:
		state_machine.transition_to("Move")
		
	if Input.is_action_just_pressed("attack_1"):
		state_machine.transition_to("SwordAtk1")
	elif Input.is_action_just_pressed("attack_2"):
		state_machine.transition_to("SpearAtk1")
	

