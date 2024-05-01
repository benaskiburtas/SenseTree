@tool
class_name TreeVisualizeSaveTreeButton
extends TreeVisualizerTreeActionButton

signal save_tree_requested(tree: SenseTree)

const BUTTON_TEXT = "Save Tree"

@export var test: String = "abc"

var selected_tree: SenseTree = null


func _init() -> void:
	super()
	_initialize_button_functionality()


func _assign_button_state() -> void:
	if self.selected_node == null:
		disabled = true
	else:
		disabled = false


func _assign_button_options() -> void:
	pass


func _initialize_button_functionality() -> void:
	disabled = false
	self.pressed.connect(_on_button_pressed)
	text = BUTTON_TEXT


func _on_button_pressed() -> void:
	save_tree_requested.emit(selected_tree)
