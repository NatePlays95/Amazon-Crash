extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var valid = true
var size_change = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_size(size):
	$Area2D/CollisionShape2D2.shape.b.x = size
	$Sprite.scale.x = size

func expand():
	size_change = 1

func shrink():
	size_change = -0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	$Sprite.scale.y += size_change*dt
	if $Sprite.scale.y < 0: $Sprite.scale.y = 0



func _on_Area2D_body_entered(body):
	if body is StaticBody2D or body is TileMap:
		visible = false
		valid = false
	pass # Replace with function body.
