@tool
class_name TreeVisualizerMoveNodeButton
extends TreeVisualizerNodeActionButton

signal move_node_requested

const BUTTON_TEXT = "Move Node"

var _is_edit_state: bool = false


func _init() -> void:
	super()
	text = BUTTON_TEXT
	get_popup().clear(true)


func _ready() -> void:
	connect("pressed", _on_button_pressed)


func _assign_button_state() -> void:
	if self.selected_node == null or selected_node.sensetree_node is SenseTree:
		disabled = true
	else:
		disabled = false


func _assign_button_options() -> void:
	pass


func _toggle_edit_state() -> void:
	_is_edit_state = !_is_edit_state


func _on_button_pressed():
	move_node_requested.emit()
	_toggle_edit_state()
