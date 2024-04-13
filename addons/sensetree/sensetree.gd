@tool
class_name SenseTreeConfiguration
extends EditorPlugin

const PLUGIN_NAME: String = "SenseTree"
const PLUGIN_ICON: Resource = preload("res://addons/sensetree/btree/icon/Tree.svg")

const TreeVisualizerEditor = preload(
	"res://addons/sensetree/tree_visualizer/scene/tree_editor.tscn"
)

var _tree_editor_instance: Node


func _enter_tree() -> void:
	add_autoload_singleton("SenseTreeHelpers", "res://addons/sensetree/common/singleton/helpers.gd")
	#add_autoload_singleton(
		#"TreeVisualizerGraphNodeStyleBoxes",
		#"res://addons/sensetree/tree_visualizer/singleton/tree_graph_node_status_panels.gd"
	#)
	#add_autoload_singleton(
		#"TreeVisualizerGraphNodeStatusPanels",
		#"res://addons/sensetree/tree_visualizer/singleton/tree_graph_node_style_boxes.gd"
	#)

	_load_tree_editor()
	_make_visible(false)


func _exit_tree() -> void:
	_remove_tree_editor()

	remove_autoload_singleton("SenseTreeHelpers")
	#remove_autoload_singleton("TreeVisualizerGraphNodeStyleBoxes")
	#remove_autoload_singleton("TreeVisualizerGraphNodeStatusPanels")


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
	_tree_editor_instance = TreeVisualizerEditor.instantiate()
	EditorInterface.get_editor_main_screen().add_child(_tree_editor_instance)


func _remove_tree_editor() -> void:
	if _tree_editor_instance:
		_tree_editor_instance.queue_free()
