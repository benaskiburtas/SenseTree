@tool
extends EditorPlugin

const PLUGIN_NAME: String = "SenseTree"
const PLUGIN_ICON: Resource = preload("res://addons/sensetree/btree/icons/Tree.svg")
const TreeVisualizer = preload("res://addons/sensetree/tree_visualizer/scenes/tree_editor.tscn")

var _tree_visualizer_instance


func _enter_tree() -> void:
	add_autoload_singleton("SenseTreeConstants", "res://addons/sensetree/common/constants.gd")	
	add_autoload_singleton("SenseTreeMessageBus", "res://addons/sensetree/common/tree_message_bus.gd")
	load_tree_visualizer()
	_make_visible(false)


func _exit_tree() -> void:
	remove_autoload_singleton("SenseTreeConstants")
	remove_autoload_singleton("SenseTreeMessageBus")
	cleanup_tree_visualizer()


func _get_plugin_name() -> String:
	return PLUGIN_NAME


func _get_plugin_icon() -> Texture2D:
	return PLUGIN_ICON


func _make_visible(visible):
	if _tree_visualizer_instance:
		_tree_visualizer_instance.visible = visible


func _has_main_screen():
	return true


func load_tree_visualizer() -> void:
	_tree_visualizer_instance = TreeVisualizer.instantiate()
	EditorInterface.get_editor_main_screen().add_child(_tree_visualizer_instance)


func cleanup_tree_visualizer() -> void:
	if _tree_visualizer_instance:
		_tree_visualizer_instance.queue_free()
