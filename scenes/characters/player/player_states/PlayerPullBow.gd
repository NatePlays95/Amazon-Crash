extends PlayerState

# Move Speed in pixels per second.
export var MOVE_SPEED := 80.0
# Friction, higher for snappy movement, lower for slippery movement.
export var FRICTION := 0.1

var input_direction : Vector2 = Vector2.ZERO

export var PULL_TIME : float = 1.0

export var PULL_SWEETSPOT_CENTER : float = 80 # in percentage
export var PULL_SWEETSPOT_RADIUS : float = 10 # in percentage

var pull : float = 0 # charges from 0 to 1

var ARROW = preload("res://scenes/characters/player/PlayerArrow.tscn")

func enter(_msg := {}) -> void:
	#player.velocity = Vector2.ZERO
	pull = 0
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
	if player.velocity.length_squared() < 25 and input_vector == Vector2.ZERO:
		#state_machine.transition_to("Idle")
		player.velocity = Vector2.ZERO


func update(dt) -> void:
	pull = min(pull + dt/PULL_TIME, 1)
	
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
		pull = 0
		state_machine.transition_to("Roll", {"roll_direction":roll_direction})
	
	# shoot button released
	if !Input.is_action_pressed("shoot"):
		if pull >= 0.1:
			shoot()
		pull = 0
		state_machine.transition_to("Move")



func shoot() -> void:
	player.bow_energy = 0
	
	var arrow_instance = ARROW.instance()
	arrow_instance.global_position = $"../../bow/axis/bow_sprite".global_position
	arrow_instance.global_rotation = $"../../bow".global_rotation
	arrow_instance.multiply_power(pull)
	arrow_instance.set_sweet(is_pull_sweet(false))
	
	
	get_tree().current_scene.add_child(arrow_instance)
	pass


func convert_pull() -> float:
	var sweetspot = PULL_SWEETSPOT_CENTER/100
	return sweetspot


var delay = 3 # percentage
#to account for input delay and human perception
func is_pull_sweet(for_display) -> bool:
	var sweetspot_min = ((PULL_SWEETSPOT_CENTER - PULL_SWEETSPOT_RADIUS)/100)
	var sweetspot_max = ((PULL_SWEETSPOT_CENTER + PULL_SWEETSPOT_RADIUS)/100)
	
	if (for_display):
		sweetspot_min -= delay/100
		sweetspot_max += delay/100
	
	return pull >= sweetspot_min and pull <= sweetspot_max
