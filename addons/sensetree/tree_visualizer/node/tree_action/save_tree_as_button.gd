@tool
class_name TreeVisualizeSaveTreeAsButton
extends TreeVisualizerTreeActionButton

signal save_tree_as_requested(tree: SenseTree)

const BUTTON_TEXT = "Save Tree As"


func _init() -> void:
	super()
	_initialize_button_functionality()


func _assign_button_state() -> void:
	if self.selected_tree == null:
		disabled = true
	else:
		disabled = false


func _initialize_button_functionality() -> void:
	self.pressed.connect(_on_button_pressed)
	text = BUTTON_TEXT


func _on_button_pressed() -> void:
	save_tree_as_requested.emit(selected_tree)
