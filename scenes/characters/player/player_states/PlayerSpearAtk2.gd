extends PlayerAttackState



var distance_factor = -32
var time_moving = 0.6

var move_tween : SceneTreeTween
var move_velocity : Vector2

func enter(_msg := {}) -> void:
	.enter(_msg)
	move_tween = create_tween().set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_IN)
	var target_position = player.global_position + player.aim_direction*distance_factor
	
	move_velocity = player.aim_direction*distance_factor / time_moving
	move_tween.tween_property(self, "move_velocity", Vector2.ZERO, time_moving)
	#create tween

func physics_update(dt) -> void:
	player.move_and_collide(move_velocity*dt)

# use this to choose which attack to transition next.
func handle_combo(input_event:InputEvent) -> void:
	if input_event.is_action_pressed("attack_1"):
		state_machine.transition_to("SwordAtk3")
	elif input_event.is_action_pressed("attack_2"):
		state_machine.transition_to("SpearAtk3")

