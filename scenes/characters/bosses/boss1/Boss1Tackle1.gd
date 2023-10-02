extends BossState

export(float) var TACKLE_DISTANCE  = 300
export(float) var TACKLE_DURATION = 0.5

#var move_direction : Vector2 = Vector2.UP
var move_vector : Vector2
var tween : SceneTreeTween

var tackle_marker_scene = load("res://scenes/characters/bosses/boss1/Boss1TackleMarker.tscn")
var iteration = 0
var tackle_markers = []

func enter(_msg := {}) -> void:
	boss.velocity = Vector2.ZERO
	iteration = 0
	boss.anim_player.play("tackle1")
	#move_direction =  (player.global_position - boss.global_position).normalized()


func physics_update(_dt) -> void:
	pass


func spawn_tackle_marker():
	var instance = tackle_marker_scene.instance()
	instance.set_size(TACKLE_DISTANCE)
	instance.rotation = PI * iteration/4
	instance.position = boss.position
	get_tree().current_scene.add_child(instance)
	tackle_markers.append(instance)
	iteration += 1

func clear_tackle_markers():
	for marker in tackle_markers:
		marker.queue_free()
		
	tackle_markers.clear()

func choose_tackle_marker():
	var chosen_marker = null
	var i = 0
	while i < 100:
		i += 1
		chosen_marker = tackle_markers[randi() % tackle_markers.size() ]
		if chosen_marker.valid: break
	assert(chosen_marker, "Couldn't choose Tackle1 direction in 100 steps")
	
	move_vector = Vector2(1, 0).rotated(chosen_marker.rotation) * TACKLE_DISTANCE
	for marker in tackle_markers:
		if marker == chosen_marker:
			marker.expand()
		else:
			marker.shrink()

func start_tackle():
	tween = get_tree().create_tween()
	tween.tween_property(boss, "global_position", move_vector, TACKLE_DURATION).as_relative()
	clear_tackle_markers()

func animation_finished(anim_name) -> void:
	if anim_name == "tackle1":
		state_machine.transition_to("SummonClones1")
