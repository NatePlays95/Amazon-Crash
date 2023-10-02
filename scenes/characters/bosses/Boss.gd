class_name Boss
extends Character


"""
Looking for something?
Most of the boss's behavior is inside the State Machine node.
"""

#export var PLAYER_PATH : NodePath
onready var target_player : Player = get_tree().get_nodes_in_group("PLAYER")[0]
onready var anim_player : AnimationPlayer = $AnimationPlayer


func _ready():
	add_to_group("TARGETABLE")
	add_to_group("BOSS")


func _process(dt):
	#print_debug(hp_rate())
	pass


# state machine help
func _on_animation_finished(anim_name):
	$StateMachine.state.animation_finished(anim_name)

func _on_hp_changed(change_amount):
	$StateMachine.state.on_hp_changed(change_amount)
