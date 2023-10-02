extends BossState

var tween : SceneTreeTween
export(float) var INITIAL_JUMP_DURATION = 0.5

export(float) var SPREAD_DISTANCE = 200
export(float) var SPREAD_DURATION = 0.8

export(bool) var can_interrupt = false

var clone_scene = load("res://scenes/characters/bosses/boss1/Boss1Clone1.tscn")
var clones_array = []

func enter(_msg := {}) -> void:
	boss.velocity = Vector2.ZERO
	#move_direction =  (player.global_position - boss.global_position).normalized()
	boss.anim_player.play("summon_clones1")
	

func go_to_center() -> void:
	tween = create_tween()
	tween.tween_property(boss, "global_position", Vector2(0,0), INITIAL_JUMP_DURATION)

func spawn_clones() -> void:
	clones_array = []
	var move_vector = Vector2(1,0).rotated(rand_range(0, 2*PI)) * SPREAD_DISTANCE
	tween = create_tween()
	tween.tween_property(boss, "global_position", move_vector, SPREAD_DURATION).as_relative()
	
	var step = 2*PI / 5
	for i in range(4):
		move_vector = move_vector.rotated(step)
		var instance = clone_scene.instance()
		instance.position = boss.global_position
		get_tree().current_scene.add_child(instance)
		instance.move(move_vector, SPREAD_DURATION)
		
		clones_array.append(weakref(instance))

func explode_clones() -> void:
	for clone in clones_array:
		if (clone.get_ref()):
			clone.get_ref().explode()
	clones_array = []



func on_hp_changed(change_amount) -> void:
	if can_interrupt and clones_array.size() > 0:
		explode_clones()

func animation_finished(anim_name) -> void:
	if anim_name == "summon_clones1":
		state_machine.transition_to("Jump1")
