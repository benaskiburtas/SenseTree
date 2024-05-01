@tool
class_name TreeVisualizeNewTreeButton
extends TreeVisualizerTreeActionButton

signal new_tree_requested

const BUTTON_TEXT = "New Tree"


func _init() -> void:
	super()
	_initialize_button_functionality()


func _assign_button_state() -> void:
	pass


func _assign_button_options() -> void:
	pass


func _initialize_button_functionality() -> void:
	disabled = false
	self.pressed.connect(_on_button_pressed)
	text = BUTTON_TEXT


func _on_button_pressed() -> void:
	new_tree_requested.emit()
