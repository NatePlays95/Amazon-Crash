extends PlayerAttackState



#var distance_factor = 16
#var time_moving = 0.4

var move_tween : SceneTreeTween
var move_velocity : Vector2

func enter(_msg := {}) -> void:
	.enter(_msg)
	#var move_tween := create_tween().set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_IN)
	
	#move_velocity = player.aim_direction*distance_factor / time_moving
	#move_tween.tween_property(self, "move_velocity", Vector2.ZERO, time_moving)
	#create tween

func step_forward() -> void:
	move_tween = create_tween().set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_IN)
	move_velocity = player.aim_direction*8 / 0.15
	move_tween.tween_property(self, "move_velocity", Vector2.ZERO, 0.15)

func rush_forward() -> void:
	move_tween = create_tween().set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_IN)
	move_velocity = player.aim_direction*48 / 0.4
	move_tween.tween_property(self, "move_velocity", Vector2.ZERO, 0.2)

func physics_update(dt) -> void:
	player.move_and_collide(move_velocity*dt)

# use this to choose which attack to transition next.
func handle_combo(input_event:InputEvent) -> void:
	if input_event.is_action_pressed("attack_1"):
		state_machine.transition_to("SwordAtk3")

