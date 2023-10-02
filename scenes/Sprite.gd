extends Sprite


export(PackedScene) var target_packed_scene 
export var speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enter():
	get_tree().change_scene_to(target_packed_scene)

