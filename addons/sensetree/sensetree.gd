@tool
class_name SenseTreeConfiguration
extends EditorPlugin

const PLUGIN_NAME: String = "SenseTree"
const PLUGIN_ICON: Resource = preload("res://addons/sensetree/btree/icons/Tree.svg")
const TreeEditor = preload("res://addons/sensetree/tree_visualizer/scenes/tree_editor.tscn")

var _undo_redo_history_manager: EditorUndoRedoManager
var _hashing_context: HashingContext

var _tree_editor_instance: Node
var _previous_hash


func _enter_tree() -> void:
	add_autoload_singleton("SenseTreeConstants", "res://addons/sensetree/common/constants.gd")
	add_autoload_singleton("SenseTreeHelpers", "res://addons/sensetree/common/helpers.gd")
	_load_tree_editor()

	_undo_redo_history_manager = get_undo_redo()
	_hashing_context = HashingContext.new()

	_make_visible(false)


func _exit_tree() -> void:
	remove_autoload_singleton("SenseTreeConstants")
	remove_autoload_singleton("SenseTreeHelpers")
	_cleanup_tree_editor()


func _get_plugin_name() -> String:
	return PLUGIN_NAME


func _get_plugin_icon() -> Texture2D:
	return PLUGIN_ICON


func _make_visible(visible):
	if _tree_editor_instance:
		_tree_editor_instance.visible = visible


func _has_main_screen():
	return true


func _load_tree_editor() -> void:
	_tree_editor_instance = TreeEditor.instantiate()
	EditorInterface.get_editor_main_screen().add_child(_tree_editor_instance)


func _cleanup_tree_editor() -> void:
	if _tree_editor_instance:
		_tree_editor_instance.queue_free()
