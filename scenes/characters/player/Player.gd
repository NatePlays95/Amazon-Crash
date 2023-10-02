class_name Player
extends Character

#export var max_hp : float = 50.0

# for attacks and projectiles
var aim_direction : Vector2 = Vector2.UP
var bow_energy : float = 0 # from 0 to 1
#NOT TO BE CONFUSED FOR BOW PULL.
var BULLET = preload("res://scenes/characters/player/PlayerBullet.tscn")

onready var anim_player : AnimationPlayer = $AnimationPlayer
onready var anim_sprite : AnimatedSprite = $AnimatedSprite
"""
Looking for something?
Most of the player's behavior is inside the State Machine node.
"""


func _ready():
	pass



# debug display
func _process(delta):
	._process(delta)
	
	aim_direction = ($PlayerCamera/aim_reticle.global_position - (self.global_position + Vector2.UP*10)).normalized()
	if aim_direction == Vector2.ZERO:
		aim_direction = Vector2.RIGHT
	
	#$DebugStateName.text = $StateMachine.state.name
	
	_render_weapons()
	_update_bow_energy(delta)
	_update_animation(delta)
	_update_hud()


func _render_weapons():
	$sword.rotation = aim_direction.angle()
	#print(aim_direction.x)
	if sign($sword.scale.y) != sign(aim_direction.x):
		$sword.scale.y *= -1
	
	$spear.rotation = aim_direction.angle()
	#print(aim_direction.x)
	if sign($spear.scale.y) != sign(aim_direction.x):
		$spear.scale.y *= -1
	
	$bow.rotation = aim_direction.angle()
	#print(aim_direction.x)
	if sign($bow.scale.y) != sign(aim_direction.x):
		$bow.scale.y *= -1
	
	$bow_pull_indicator/fg.scale.y = clamp($StateMachine/PullBow.pull, 0, 1)


func _update_bow_energy(dt) -> void:
	#debug: regen with time
	var regen_length = 10 #seconds
	if bow_energy < 1:
		bow_energy = clamp(bow_energy + dt/regen_length, 0, 1)
	
	if $StateMachine/PullBow.is_pull_sweet(true):
		$bow_pull_indicator/fg.texture.fill_to.y = 0.98
	else:
		$bow_pull_indicator/fg.texture.fill_to.y = 0
	

func _update_animation(_dt) -> void:
	if velocity.length() < 1:
		anim_sprite.frame = 0
		return
	
	var vvector = velocity
	var direction = null
	if vvector.x > 0:
		if vvector.x > abs(vvector.y):
			direction = "right"
		else: 
			if vvector.y > 0:
				direction = "down"
			else:
				direction = "up"
	else:
		if vvector.x < -abs(vvector.y):
			direction = "left"
		else: 
			if vvector.y > 0:
				direction = "down"
			else:
				direction = "up"
	
	anim_sprite.play(direction)

func _update_hud() -> void:
	$PlayerHUD/health_display/bar/fg.rect_scale.x = clamp(hp/max_hp, 0, 1)
	$PlayerHUD/bow_energy_display/bar/fg.rect_scale.x = bow_energy 


func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()



func shoot():
	pass
#	var cur_state = $StateMachine.get_state_name()
#	print(cur_state)
#	if $StateMachine.state != $StateMachine/Roll and $StateMachine.state != $StateMachine/Dead:
#		var bullet_instance = BULLET.instance()
#		bullet_instance.global_position = global_position + aim_direction*24 + Vector2.UP*8
#		bullet_instance.direction = aim_direction
#		
#		get_tree().current_scene.add_child(bullet_instance)


# state machine help
func _on_animation_finished(anim_name):
	$StateMachine.state.animation_finished(anim_name)


func _on_Player_hp_changed(new_hp):
	if new_hp <= 0:
		$StateMachine.transition_to("Dead")
