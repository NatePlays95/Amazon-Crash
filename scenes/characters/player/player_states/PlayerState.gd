class_name PlayerState
extends State


var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	# waits for the "ready" signal to be emitted from the owner
	# we want to setup only when the player is ready and instanced.
	yield(owner, "ready") 
	
	player = owner as Player # null if owner is not player
	assert(player != null) # throws error if player is null


func animation_finished(_anim_name:String) -> void:
	pass
