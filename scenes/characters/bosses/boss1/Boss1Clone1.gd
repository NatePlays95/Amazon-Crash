extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tween : SceneTreeTween
var can_be_hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func move(move_vector:Vector2, duration:float):
	tween = create_tween()
	tween.tween_property(self, "global_position", move_vector, duration).as_relative()
	tween.tween_property(self, "can_be_hit", true, 0.01)

func explode():
	#placeholder
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_hurtbox_area_entered(area):
	if can_be_hit and area is Hitbox and area.source == Hitbox.eSOURCE.PLAYER:
		explode()
