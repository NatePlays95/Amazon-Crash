extends PlayerState

# Move Speed in pixels per second.
export var MOVE_SPEED := 300.0
# Friction, higher for snappy movement, lower for slippery movement.
export var FRICTION := 0.2

var input_direction : Vector2 = Vector2.ZERO

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	input_direction =  Vector2.ZERO


func physics_update(_dt) -> void:
	
	var input_vector := Vector2(
		Input.get_axis("move_left","move_right"), 
		Input.get_axis("move_up","move_down")
	)
	# save some performance on square root ops
	if input_vector.length() > 1: input_vector = input_vector.normalized()
	input_direction = input_vector
	
	var target_velocity = input_vector * MOVE_SPEED
	
	# apply movement
	# move_and_slide doesn't need delta, it handles it internally
	player.velocity += (target_velocity - player.velocity)*FRICTION
	player.velocity = player.move_and_slide(player.velocity) 
	
	# if stopped, go back to idle. length_squared saves us a sqrt op
	#print_debug("speed: ",player.velocity.length_squared())
	#if is_equal_approx(player.velocity.length_squared(), 0): 
	if player.velocity.length_squared() < 100 and input_vector == Vector2.ZERO:
		#state_machine.transition_to("Idle")
		player.velocity = Vector2.ZERO


func update(_dt) -> void:
	if player.velocity != Vector2.ZERO:
		#player.anim_player.play("walk")
		pass
	else:
		#player.anim_player.play("idle")
		pass



func handle_input(_event) -> void:
	if Input.is_action_just_pressed("roll"):
		var roll_direction = Vector2.UP
		if input_direction != Vector2.ZERO:
			roll_direction = input_direction
		else:
			roll_direction = player.aim_direction
		
		state_machine.transition_to("Roll", {"roll_direction":roll_direction})
	
	if Input.is_action_just_pressed("attack_1"):
		state_machine.transition_to("SwordAtk1")
	elif Input.is_action_just_pressed("attack_2"):
		state_machine.transition_to("SpearAtk1")
	
	if Input.is_action_pressed("shoot"):
		if player.bow_energy == 1:
			state_machine.transition_to("PullBow")
	

