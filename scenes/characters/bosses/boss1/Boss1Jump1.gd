extends BossState

var move_direction : Vector2 = Vector2.UP
var tween : SceneTreeTween

var jump_time = 0

var scene_stomp = load("res://scenes/characters/bosses/boss1/attacks/Stomp.tscn")

func enter(_msg := {}) -> void:
	boss.velocity = Vector2.ZERO
	#move_direction =  (player.global_position - boss.global_position).normalized()
	print_debug("started_jump")
	jump_time = 0
	boss.anim_player.play("jump1")
	


func physics_update(_dt) -> void:
	if jump_time > 0:
		jump(jump_time)
		jump_time = 0

func jump(duration:float) -> void:
	#print_debug(player.global_position, "haçlo", boss.global_position)
	#var movement_vector = (player.global_position - boss.global_position)
	#print_debug("duration",duration)
	tween = create_tween()
	tween.tween_property(boss, "global_position", player.global_position, duration)

func set_jump_time(value):
	jump_time = value

func spawn_stomp():
	var instance = scene_stomp.instance()
	instance.scale = Vector2.ZERO
	boss.add_child(instance)

func animation_finished(anim_name) -> void:
	print("animationfinished: ",anim_name)
	if anim_name == "jump1":
		state_machine.transition_to("Tackle1")
