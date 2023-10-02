extends BossState

# Move Speed in pixels per second.
export (float) var MOVE_SPEED := 100.0
# Friction, higher for snappy movement, lower for slippery movement.
export (float) var FRICTION := 0.2
# 1 is instant
export (float) var ROTATION_FACTOR := 0.5 

var next_state_timer : float = 1

var move_direction : Vector2 = Vector2.UP


func enter(_msg := {}) -> void:
	boss.velocity = Vector2.ZERO
	move_direction =  (player.global_position - boss.global_position).normalized()
	
	next_state_timer = 3 + randf()*3
	#print("a")


func physics_update(dt) -> void:
	if player:
		var target_direction = (player.global_position - boss.global_position).normalized()
		var target_angle = target_direction.angle()
		
		
		var move_angle = lerp_angle(move_direction.angle(), target_angle, ROTATION_FACTOR)
		move_direction = Vector2.RIGHT.rotated(move_angle)
	#print(player.global_position)
	# apply movement
	# move_and_slide doesn't need delta, it handles it internally
	boss.velocity += (move_direction*MOVE_SPEED - boss.velocity)*FRICTION
	boss.velocity = boss.move_and_slide(boss.velocity) 
	# if stopped, go back to idle. length_squared saves us a sqrt op
	if boss.velocity.length_squared() < 25 and move_direction == Vector2.ZERO:
		#state_machine.transition_to("Idle")
		boss.velocity = Vector2.ZERO

func update(dt) -> void:
	next_state_timer -= dt
	
	if next_state_timer <= 0:
		state_machine.transition_to("Jump1")
