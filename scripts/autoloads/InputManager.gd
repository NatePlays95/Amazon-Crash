extends Node


enum eMODE {
	KEYBOARD, CONTROLLER 
}
onready var input_mode = eMODE.KEYBOARD


func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		input_mode = eMODE.CONTROLLER
	elif event is InputEventKey or event is InputEventMouse:
		input_mode = eMODE.KEYBOARD


