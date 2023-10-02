extends PlayerState

# Move Speed in pixels per second.
export var ROLL_START_SPEED := 500.0
export var ROLL_END_SPEED := 200.0
export var DURATION = 0.45 #these dont quite work!
export var IFRAME_DURATION = 0.2
#todo: set STARTING SPEED, FINAL SPEED, TIME MOVING
#CHANGE I-FRAME DURATION INSIDE ANIMATION

var move_tween : SceneTreeTween
var move_speed : float

var move_direction : Vector2# = Vector2.ZERO
#var timer : float

func enter(msg := {"roll_direction":Vector2.DOWN}) -> void:
	.enter(msg)
	move_direction = msg["roll_direction"]
	move_tween = create_tween().set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_IN)
	move_speed = ROLL_START_SPEED
	move_tween.tween_property(self, "move_speed", ROLL_END_SPEED, DURATION)
	player.set_invincible(IFRAME_DURATION)
	player.anim_player.play("RESET")
	player.anim_player.queue("roll")


func physics_update(dt) -> void:
	# apply movement
	# move_and_slide doesn't need delta, it handles it internally
	player.move_and_slide(move_direction*move_speed) 
	
	# when duration ends, go back to Move
	#if timer <= 0.0:
	#	state_machine.transition_to("Move")


func animation_finished(anim_name) -> void:
	if anim_name == "roll":
		state_machine.transition_to("Move")
