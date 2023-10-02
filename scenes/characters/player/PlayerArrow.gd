extends Node2D

var timer : float = 0.0
var is_sweet : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(dt):
	$Noise.texture.noise_offset.x += dt*256
	$Noise.modulate.a = clamp($Noise.modulate.a - dt/1, 0, 1)
	
	timer += dt
	if timer > 1:
		queue_free()
	
	if timer > 0.1:
		$Hitbox/CollisionShape2D.disabled = true

func set_sweet(value):
	is_sweet = value
	$Noise.visible = value
	$Hitbox.damage *= 3 if is_sweet else 1 # multiply damage by 2 if sweet


func multiply_power(factor):
	$Hitbox.damage *= factor


