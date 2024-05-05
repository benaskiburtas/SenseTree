@tool
class_name TreeVisualizeSaveTreeButton
extends TreeVisualizerTreeActionButton

signal save_tree_requested(tree: SenseTree)

const BUTTON_TEXT = "Save Tree"


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
	print("SaveTreeButton Log: Button Pressed")
	save_tree_requested.emit(selected_tree)
	print("SaveTreeButton Log: Signal save_tree_requested emitted")
