@tool
class_name TreeVisualizeLoadTreeButton
extends TreeVisualizerTreeActionButton

signal load_tree_requested

const BUTTON_TEXT: String = "Load Tree"


func _init() -> void:
	super()
	_initialize_button_functionality()


func _assign_button_state() -> void:
	disabled = false


func _assign_button_options() -> void:
	pass


func _initialize_button_functionality() -> void:
	disabled = false
	self.pressed.connect(_on_button_pressed)
	text = BUTTON_TEXT


func _on_button_pressed() -> void:
	load_tree_requested.emit()
