class_name Character
extends KinematicBody2D



var DMG_POPUP = preload("res://scenes/ui/Damage Popup.tscn")

export var velocity : Vector2 = Vector2.ZERO
export var direction : Vector2 = Vector2.DOWN



""" HP STUFF """
signal hp_changed(new_hp)
export (float) var max_hp : float = 10.0
var hp : float = 10 setget set_hp, get_hp

func _ready():
	hp = max_hp

func set_hp(amount) -> void:
	amount = clamp(amount, 0, max_hp)
	hp = amount
	emit_signal("hp_changed",hp)

func get_hp() -> float:
	return hp

func damage_hp(damage) -> void:
	set_hp(hp - damage)

func hp_rate() -> float:
	return clamp(get_hp()/max_hp, 0.0, 1.0)

""" HIT DETECTION """
# invincibility timer
onready var inv_timer : SceneTreeTimer = get_tree().create_timer(0)
#var invincible : bool = false setget , is_invincible # no setter
func is_invincible():
	#return not inv_timer.is_stopped()
	return inv_timer.time_left > 0
func set_invincible(duration:float):
	#inv_timer.wait_time = duration
	#inv_timer.start()
	inv_timer = get_tree().create_timer(duration)

# how much time to stay invincible after hurt
export var INV_AFTER_HIT : float = 1.0 # in seconds
# this exists because the same timer is used for rolling, with other durations.

func _on_hurtbox_area_entered(area)->void:
	if area is Hitbox:
		_on_hurtbox_meets_hitbox(area)

func _on_hurtbox_meets_hitbox(hitbox:Hitbox)->void:
	# please don't be hit by your own hitbox.
	#if hitbox.source == Hitbox.eSOURCE.ENEMY and self is Boss: return
	#if hitbox.source == Hitbox.eSOURCE.PLAYER and self is Player: return
	# can't damage player on i-frames
	if is_invincible() and not hitbox.ignore_invincibility: return
	
	var damage = hitbox.damage
	# actually process damage!
	damage_hp(damage)
	#show popup
	var popup_instance = DMG_POPUP.instance()
	popup_instance.global_position = self.global_position + 8*Vector2.UP.rotated(rand_range(0, 2*PI))
	popup_instance.set_damage(damage)
	get_tree().get_root().add_child(popup_instance)
	
	
	# TODO: process hitstun if there's any
	
	# TODO: process knockback
	
	# become invincible momentarily
	#inv_timer.wait_time = INV_AFTER_HIT
	#inv_timer.start()
	set_invincible(INV_AFTER_HIT)


func move_and_slide(linear_velocity: Vector2, up_direction: Vector2 = Vector2( 0, 0 ),
		stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398,
		 infinite_inertia: bool = true) -> Vector2:
	self.velocity = .move_and_slide(linear_velocity,up_direction,stop_on_slope,
		max_slides,floor_max_angle,infinite_inertia)
	return self.velocity


func move_and_collide(rel_vec: Vector2, infinite_inertia: bool = true,
		 exclude_raycast_shapes: bool = true, test_only: bool = false) -> KinematicCollision2D:
	var col = .move_and_collide(rel_vec,infinite_inertia,exclude_raycast_shapes,test_only)
	if col and col.remainder.length_squared() > 0:
		self.velocity = rel_vec
	else:
		self.velocity = Vector2.ZERO
	return col



""" PROCESS """
func _process(_delta):
	_debug_display()
	_process_zsort()
	

func _debug_display():
	#print("Time left: ",inv_timer.time_left)
	
	for child in get_children():
		if child is Sprite or child is AnimatedSprite:
			if is_invincible():
				child.modulate.a = 0.5
			else:
				child.modulate.a = 1

func _process_zsort():
	z_index = global_position.y * 0.5


"""
Looking for something?
Most of the player's behavior is inside the State Machine node.
"""
