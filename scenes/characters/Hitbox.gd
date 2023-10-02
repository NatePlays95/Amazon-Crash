class_name Hitbox
extends Area2D



enum eSOURCE { PLAYER, ENEMY }
export(eSOURCE) var source = eSOURCE.PLAYER

func from_player() -> bool:
	return source == eSOURCE.PLAYER

func from_enemy() -> bool:
	return source == eSOURCE.ENEMY



export(float, 0.0, 100.0) var damage = 1.0
export(float, 0.0, 10.0) var stun = 1.0
export(float, -100.0, 100.0) var knockback = 10.0
export(bool) var ignore_invincibility = false


func _ready():
	self.collision_layer = 0
	self.collision_mask = 0
	if source == eSOURCE.PLAYER:
		self.set_collision_mask_bit(3, true) #collide with enemies
	elif source == eSOURCE.ENEMY:
		self.set_collision_mask_bit(2, true) #collide with player
