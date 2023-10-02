
extends PlayerAttackState



var distance_factor = 256
var time_moving = 0.7

var move_tween : SceneTreeTween
var move_velocity : Vector2

func enter(_msg := {}) -> void:
	.enter(_msg)
	var move_tween := create_tween().set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_IN)
	var target_position = player.global_position + player.aim_direction*distance_factor
	
	move_velocity = player.aim_direction*distance_factor / time_moving
	move_tween.tween_property(self, "move_velocity", Vector2.ZERO, time_moving)

func physics_update(dt) -> void:
	player.move_and_slide(move_velocity)#already uses delta

# use this to choose which attack to transition next.
# VIRTUAL 
func handle_combo(_input_event:InputEvent) -> void:
	pass

