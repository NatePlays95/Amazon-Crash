extends Node2D


var tween : SceneTreeTween
export var travel_height : float = 32
export var travel_duration : float = 0.4
export var fade_out_duration : float = 0.4
# Called when the node enters the scene tree for the first time.

func _ready():
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", global_position+Vector2.UP*travel_height, travel_duration)
	tween.tween_property(self, "modulate:a", 0.0, fade_out_duration)
	tween.tween_callback(self, "queue_free")
	z_index = 2000
	#create_tween(self, "global_position", global_position+UP*)
	pass # Replace with function body.

func set_damage(amount:float):
	if floor(amount) == amount:
		$Label.text = str(amount)
	else:
		$Label.text = str("%1.2f" % amount)
