extends Control



var boss : Boss = null

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.



func _process(delta):
	if boss == null: _find_boss()
	pass


func _find_boss():
	if len(get_tree().get_nodes_in_group("BOSS")) <= 0: return
	var boss_candidate : Boss = get_tree().get_nodes_in_group("BOSS")[0]
	if boss_candidate == null: return
	
	boss = boss_candidate
	boss.connect("hp_changed", self, "_on_hp_changed")
	refresh()
	$AnimationPlayer.play("open")
	visible = true


func _on_hp_changed(new_hp):
	refresh()


func refresh():
	$name.text = boss.name
	$fg.rect_scale.x = boss.hp_rate()
	pass
