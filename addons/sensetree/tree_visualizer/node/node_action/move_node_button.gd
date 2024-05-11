@tool
class_name TreeVisualizerMoveNodeButton
extends TreeVisualizerNodeActionButton

signal move_node_requested

const BUTTON_TEXT = "Move Node"

var _edit_mode_active_stylebox: StyleBox
var _edit_mode_disabled_stylebox: StyleBox
var _edit_mode_focus_stylebox: StyleBox
var _edit_mode_hover_stylebox: StyleBox
var _edit_mode_normal_stylebox: StyleBox

var is_edit_state: bool = false:
	set(new_is_edit_state):
		is_edit_state = new_is_edit_state
		_apply_style_state()


func _init() -> void:
	super()
	text = BUTTON_TEXT
	get_popup().clear(true)


func _enter_tree():
	_edit_mode_active_stylebox = get_theme_stylebox("active_edit_mode_move_node_button")
	_edit_mode_disabled_stylebox = get_theme_stylebox("disabled_edit_mode_move_node_button")
	_edit_mode_focus_stylebox = get_theme_stylebox("focus_edit_mode_move_node_button")
	_edit_mode_hover_stylebox = get_theme_stylebox("hover_edit_mode_move_node_button")
	_edit_mode_normal_stylebox = get_theme_stylebox("normal_edit_mode_move_node_button")


func _ready() -> void:
	connect("pressed", _on_button_pressed)


func toggle_edit_state() -> void:
	is_edit_state = !is_edit_state


func _assign_button_state() -> void:
	if self.selected_node == null or selected_node.sensetree_node is SenseTree:
		disabled = true
	else:
		disabled = false


func _apply_style_state() -> void:
	if is_edit_state:
		add_theme_stylebox_override("active", _edit_mode_active_stylebox)
		add_theme_stylebox_override("disabled", _edit_mode_disabled_stylebox)
		add_theme_stylebox_override("focus", _edit_mode_focus_stylebox)
		add_theme_stylebox_override("hover", _edit_mode_hover_stylebox)
		add_theme_stylebox_override("normal", _edit_mode_normal_stylebox)
	else:
		remove_theme_stylebox_override("active")
		remove_theme_stylebox_override("disabled")
		remove_theme_stylebox_override("focus")
		remove_theme_stylebox_override("hover")
		remove_theme_stylebox_override("normal")


func _on_button_pressed():
	get_popup().hide()
	toggle_edit_state()
	move_node_requested.emit()
