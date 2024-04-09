@tool
extends EditorPlugin

const PLUGIN_NAME: String = "SenseTree"
const PLUGIN_ICON: Resource = preload("res://addons/sensetree/btree/icons/Tree.svg")
const TREE_VISUALIZER: Resource = preload(
	"res://addons/sensetree/tree_visualizer/tree_visualizer.gd"
)

var _tree_visualizer_instance: SenseTreeVisualizer


func _init():
	pass


func _get_plugin_name() -> String:
	return PLUGIN_NAME


func _get_plugin_icon() -> Texture2D:
	return PLUGIN_ICON


func _enter_tree() -> void:
	add_autoload_singleton("SenseTreeConstants", "res://addons/sensetree/constants.gd")
	load_tree_visualizer()


func _exit_tree() -> void:
	cleanup_tree_visualizer()
	remove_autoload_singleton("SenseTreeConstants")


func _has_main_screen():
	return true


func load_tree_visualizer() -> void:
	_tree_visualizer_instance = TREE_VISUALIZER.new()
	EditorInterface.get_editor_main_screen().add_child(_tree_visualizer_instance)


func cleanup_tree_visualizer() -> void:
	_tree_visualizer_instance.queue_free()
