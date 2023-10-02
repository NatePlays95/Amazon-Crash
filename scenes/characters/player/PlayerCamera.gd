extends Camera2D


enum MODE { FOLLOW, AIM, FOCUS, ANCHOR }
var mode = MODE.AIM

var target_gpos = Vector2.ZERO # in global space
var target_node = null

var tween : SceneTreeTween

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	$camera_reticle.visible = true
	
	yield(owner, "ready")
	player = owner as Player
	
	switch_mode(mode)


func _process(_dt):
	_process_reticle(_dt)
	
	var lerp_speed := 0.5
	match mode:
		MODE.FOLLOW:
			# simulate lerping or tweening behavior
			target_gpos = (player.global_position + self.global_position)/2
			
		MODE.AIM:
			target_gpos = (player.global_position + $camera_reticle.global_position)/2
			$camera_reticle.global_position = $aim_reticle.global_position
			
		MODE.FOCUS:
			if target_node == null:
				print("fallback to follow mode")
				switch_mode(MODE.FOLLOW)
				return
			
			$camera_reticle.global_position = target_node.global_position
			target_gpos = (target_node.global_position + player.global_position)/2
			
		MODE.ANCHOR:
			if target_node == null:
				print("fallback to follow mode")
				switch_mode(MODE.FOLLOW)
				return
			
			# smooth approach
			if target_gpos != target_node.global_position:
				target_gpos = lerp(target_gpos, target_node.global_position, 0.5)
			# but stay anchored later
			lerp_speed = 1.0
		
	global_position = lerp(global_position, target_gpos, lerp_speed)


func _process_reticle(dt):
	$aim_reticle.rotation += dt*PI
	$camera_reticle.rotation += dt*PI
	
	if InputManager.input_mode == InputManager.eMODE.KEYBOARD:
		$aim_reticle.global_position = get_global_mouse_position()
	elif InputManager.input_mode == InputManager.eMODE.CONTROLLER:
		var distance = 32
		var input_vector = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		).normalized()
		if input_vector.length() > 0.1: #deadzone
			var target_pos = player.global_position + input_vector * distance + Vector2(0.5, 0.5)
			$aim_reticle.global_position = lerp($aim_reticle.global_position, target_pos, 0.05)


func _input(event)->void:
	var key_event := event as InputEventKey
	if key_event == null: return
	
	if key_event.pressed:
		
		if key_event.scancode == KEY_C:
			switch_mode()
			print("camera mode changed: ", mode)
		
		if key_event.scancode == KEY_TAB:
			switch_target()



func switch_mode(to_mode = null):
	if to_mode == null: # jump to the next mode in order
		match mode:
			MODE.FOLLOW: switch_mode(MODE.AIM)
			MODE.AIM: switch_mode(MODE.FOCUS)
			MODE.FOCUS: switch_mode(MODE.ANCHOR)
			MODE.ANCHOR: switch_mode(MODE.FOLLOW)
	
	else: # handle the desired mode
		mode = to_mode
		match mode:
			MODE.AIM:
				$camera_reticle.visible = true
			MODE.FOLLOW:
				$camera_reticle.position = Vector2.ZERO
				$camera_reticle.visible = false
			MODE.FOCUS:
				$camera_reticle.visible = true # TODO: remove this later
				switch_target()
			MODE.ANCHOR:
				$camera_reticle.position = Vector2.ZERO
				$camera_reticle.visible = false
				switch_target()



func switch_target(intended_target_path = null):
	var target_array = get_tree().get_nodes_in_group("TARGETABLE")
	print(target_array)
	if target_array.size() == 0: return
	
	match intended_target_path:
		null: # choose next possible target
			if target_node == null:
				target_node = target_array[0]
			else:
				var index = target_array.find(target_node) + 1
				if index >= target_array.size(): index -= target_array.size()
				target_node = target_array[index]
			
		_: # has a set target
			target_node = get_node_or_null(intended_target_path)
	
	if target_node == null:
		switch_mode(MODE.FOLLOW)
		print("fallback to follow mode")
		return
	
	

