@tool
class_name TreeVisualizeSaveTreeButton
extends TreeVisualizerTreeActionButton

signal save_tree_requested

const BUTTON_TEXT = "Save Tree"


func _init() -> void:
	super()
	text = BUTTON_TEXT
	self.pressed.connect(_on_button_pressed)
	disabled = false


func _assign_button_state() -> void:
	disabled = false


func _assign_button_options() -> void:
	pass


func _on_button_pressed() -> void:
	print("test")
