class_name BossState
extends State


var player : Player
var boss : Boss

# Called when the node enters the scene tree for the first time.
func _ready():
	# waits for the "ready" signal to be emitted from the owner
	# we want to setup only when the player is ready and instanced.
	yield(owner, "ready") 
	
	boss = owner as Boss # null if owner is not player
	assert(boss != null) # throws error if player is null
	player = boss.target_player


func animation_finished(_anim_name:String) -> void:
	pass

func on_hp_changed(new_hp) -> void:
	if new_hp <= 0:
		state_machine.transition_to("Dead")
