extends PlayerAttackState



var distance_factor = 8
var time_moving = 0.4

var scene_slash1 = load("res://scenes/characters/player/player_attacks/SwordSlash1.tscn")

func enter(_msg := {}) -> void:
	.enter(_msg)
	step(distance_factor, time_moving)
	
	var slash_instance = scene_slash1.instance()
	slash_instance.position = player.get_node("sword").position
	slash_instance.rotation = player.aim_direction.angle()
	player.add_child(slash_instance)
	#create tween

func physics_update(dt) -> void:
	.physics_update(dt)

# use this to choose which attack to transition next.
func handle_combo(input_event:InputEvent) -> void:
	if input_event.is_action_pressed("attack_1"):
		state_machine.transition_to("SwordAtk2")
	elif input_event.is_action_pressed("attack_2"):
		state_machine.transition_to("SpearAtk2")

