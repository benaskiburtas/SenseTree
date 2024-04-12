@tool
class_name TreeVisualizerDeleteNodeButton
extends TreeVisualizerActionButton

signal delete_node_requested(node: TreeVisualizerGraphNode)

const BUTTON_TEXT = "Delete Node"
const CONFIRM_TEXT = "Confirm"

const WarningIcon: Texture2D = preload("res://addons/sensetree/tree_visualizer/assets/icons/warning.svg")

func _init() -> void:
	super()
	text = BUTTON_TEXT
	_populate_confirm_submenu()

func _assign_button_state() -> void:
	if self.selected_node == null:
		disabled = true
	else:
		disabled = false


func _assign_button_options() -> void:
	pass

func _populate_confirm_submenu() -> void:
	var popup_container = get_popup()
	popup_container.add_icon_item(WarningIcon, CONFIRM_TEXT)
	popup_container.connect("index_pressed", _on_delete_node_pressed)


func _on_delete_node_pressed(index: int):
	delete_node_requested.emit(self.selected_node)
