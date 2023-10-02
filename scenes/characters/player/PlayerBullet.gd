extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction : Vector2 = Vector2.RIGHT
export var speed : float = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	move_and_collide(direction*speed*delta)
	#print(direction)


func _on_hit_area(area):
	if area is Hurtbox:
		print("kapow!")
		queue_free()

func _on_hit_wall(body):
	print("bonk")
	queue_free()

func _on_Timer_timeout():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




