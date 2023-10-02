class_name Hurtbox
extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var damage_multiplier : float = 1
export(Hitbox.eSOURCE) var type = Hitbox.eSOURCE.PLAYER

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("area_entered", get_parent(), "_on_hurtbox_area_entered")
	
	self.collision_layer = 0
	self.collision_mask = 0
	if type == Hitbox.eSOURCE.PLAYER:
		self.set_collision_layer_bit(2, true) #is player hitbox
	elif type == Hitbox.eSOURCE.ENEMY:
		self.set_collision_layer_bit(3, true) #enemy


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
