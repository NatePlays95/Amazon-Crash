extends Projectile

onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("default")
