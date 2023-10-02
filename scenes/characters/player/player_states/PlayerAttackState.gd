class_name PlayerAttackState
extends PlayerState





# to be accessed by animationplayer exclusively
export var can_roll = false
export var can_combo = false


# animation to be called from player.$anims
export(String) var animation_name = ""

# for mini "step" animation
var step_velocity : Vector2

func enter(_msg := {}) -> void:
	player.anim_player.stop(true)
	can_roll = false
	can_combo = false
	player.anim_player.play("RESET")
	player.anim_player.queue(animation_name)


func physics_update(_dt) -> void:
	update_step()


# mini "step" animation when needed
func step(distance:float = 16, duration:float = 0.2) -> void:
	var step_tween = create_tween().set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_IN)
	step_velocity = player.aim_direction*distance*2 / duration
	step_tween.tween_property(self, "step_velocity", Vector2.ZERO, duration)


func update_step() -> void:
	player.move_and_slide(step_velocity)


func handle_input(_event) -> void:
	if Input.is_action_just_pressed("roll") and can_roll:
		var input_vector := Vector2(
			Input.get_axis("move_left","move_right"), 
			Input.get_axis("move_up","move_down"))
		if input_vector.length_squared() > 1:
			input_vector = input_vector.normalized()
		
		var roll_direction = Vector2.UP
		if input_vector != Vector2.ZERO:
			roll_direction = input_vector
		else:
			roll_direction = player.aim_direction
		
		state_machine.transition_to("Roll", {"roll_direction":roll_direction})
		return # can't detect combo AND roll at the same time; roll has priority
	
	if can_combo and _event is InputEvent:
		handle_combo(_event)


# use this to choose which attack to transition next.
# VIRTUAL 
func handle_combo(_input_event:InputEvent) -> void:
	pass


func animation_finished(anim_name:String):
	if anim_name == animation_name:
		#transition to idle state here.
		state_machine.transition_to("Move")

