@tool
class_name TreeVisualizerContainer
extends Container

const IDLE_POLL_RATE: int = 100
const PHYSICS_POLL_RATE: int = 100

const TreeFileManager: Resource = preload(
	"res://addons/sensetree/tree_visualizer/node/tree_file_manager.gd"
)

var _process_mode: SenseTreeConstants.ProcessMode = SenseTreeConstants.ProcessMode.PHYSICS

var _selected_tree: SenseTree
var _selected_node: TreeVisualizerGraphNode

var _current_idle_tick_count: int = 0
var _current_physics_tick_count: int = 0

var _file_manager: TreeVisualizerFileManager
var _graph_edit: TreeVisualizerGraphEdit


func _ready() -> void:
	_initialize_file_manager()
	_initiliaze_graph_edit()
	_setup_process_mode()
	_connect_graph_edit_signals()
	_connect_file_manager_signals()


func _process(delta) -> void:
	_process_frame(SenseTreeConstants.ProcessMode.IDLE)


func _physics_process(delta) -> void:
	_process_frame(SenseTreeConstants.ProcessMode.PHYSICS)


func _initialize_file_manager() -> void:
	_file_manager = TreeFileManager.new()
	add_child(_file_manager)


func _initiliaze_graph_edit() -> void:
	_graph_edit = $TreeGraphEditor


func _process_frame(mode: SenseTreeConstants.ProcessMode) -> void:
	match mode:
		SenseTreeConstants.ProcessMode.IDLE:
			_current_idle_tick_count += 1
			if _current_idle_tick_count >= IDLE_POLL_RATE:
				_current_idle_tick_count = 0
			else:
				return
		SenseTreeConstants.ProcessMode.PHYSICS:
			_current_physics_tick_count += 1
			if _current_physics_tick_count >= PHYSICS_POLL_RATE:
				_current_physics_tick_count = 0
			else:
				return

	if _selected_tree:
		_file_manager.reload_tree()


func _setup_process_mode() -> void:
	set_process(_process_mode == SenseTreeConstants.ProcessMode.IDLE)
	set_physics_process(_process_mode == SenseTreeConstants.ProcessMode.PHYSICS)


func _connect_graph_edit_signals() -> void:
	_graph_edit.connect("node_selected", _on_node_selected)
	_graph_edit.connect("node_deselected", _on_node_deselected)
	if Engine.is_editor_hint():
		_graph_edit.new_tree_button.connect("new_tree_requested", _on_new_tree_requested)
		_graph_edit.load_tree_button.connect("load_tree_requested", _on_load_tree_requested)
		_graph_edit.save_tree_button.connect("save_tree_requested", _on_save_tree_requested)
		_graph_edit.save_tree_as_button.connect(
			"save_tree_as_requested", _on_save_tree_as_requested
		)
		_graph_edit.add_node_button.connect("create_node_requested", _on_create_node_requested)
		_graph_edit.delete_node_button.connect("delete_node_requested", _on_delete_node_requested)


func _connect_file_manager_signals() -> void:
	_file_manager.connect("tree_loaded", _on_tree_loaded)


func _force_redraw() -> void:
	_current_idle_tick_count = IDLE_POLL_RATE + 1
	_current_physics_tick_count = PHYSICS_POLL_RATE + 1
	_process_frame(_process_mode)


func _reset_elements() -> void:
	_disable_graph_edit_action_buttons()
	if _selected_tree:
		_graph_edit.assign_tree(_selected_tree)
	else:
		_graph_edit.reset()


func _get_tree_sense_nodes(root: Node) -> Array:
	var result = []
	if root is SenseTreeNode:
		result.append(root)

	if root:
		for child in root.get_children():
			result.append_array(_get_tree_sense_nodes(child))

	return result


func _select_node_in_editor(selected_node: TreeVisualizerGraphNode) -> void:
	if not selected_node:
		push_warning(
			"SenseTree Visualizer Warning: Cannot match in-editor node selection as no visualizer node is selected."
		)
		return

	if not selected_node.node:
		push_warning(
			"SenseTree Visualizer Warning: Cannot match in-editor node selection as the underlying graph node is missing."
		)
		return

	var node_name = selected_node.node.name

	# Select matching node in scene list
	var inspector_root_node: Node = EditorInterface.get_edited_scene_root()

	var matching_editor_node: Node
	if inspector_root_node:
		if inspector_root_node.name == node_name:
			matching_editor_node = inspector_root_node
		else:
			inspector_root_node.find_child(node_name, true)

	if not matching_editor_node:
		return

	var scene_selector: EditorSelection = EditorInterface.get_selection()
	scene_selector.clear()
	scene_selector.add_node(matching_editor_node)


func _disable_graph_edit_action_buttons() -> void:
	_graph_edit.add_node_button.selected_node = null
	_graph_edit.delete_node_button.selected_node = null


func _on_node_selected(selected_node: TreeVisualizerGraphNode) -> void:
	# Exit early if running not in-editor
	if not Engine.is_editor_hint():
		return

	if not selected_node is TreeVisualizerGraphNode:
		return

	_selected_node = selected_node
	_select_node_in_editor(selected_node)
	_graph_edit.add_node_button.selected_node = selected_node
	_graph_edit.delete_node_button.selected_node = selected_node


func _on_node_deselected(deselected_node: Node) -> void:
	_disable_graph_edit_action_buttons()


func _on_new_tree_requested() -> void:
	_file_manager.new_tree()


func _on_load_tree_requested() -> void:
	_file_manager.load_tree()


func _on_save_tree_requested(tree: SenseTree) -> void:
	_file_manager.save_tree(tree)


func _on_save_tree_as_requested(tree: SenseTree) -> void:
	_file_manager.save_tree_as(tree)


func _on_create_node_requested(node_class: String) -> void:
	_disable_graph_edit_action_buttons()

	if not _selected_node:
		push_warning("Cannot instantiate new node as no selected node was found.")
		return

	var node_script_path = SenseTreeHelpers.try_acquire_script_path(node_class)
	if not node_script_path:
		push_warning("Could not resolve script path for SenseTree node %s." % node_class)
		return

	var node = _selected_node.node
	var node_script: Script = load(node_script_path)
	var new_node_instance: SenseTreeNode = node_script.new()

	new_node_instance.set_name(node_class)
	node.add_child(new_node_instance, true)
	new_node_instance.set_owner(node)

	_file_manager.resave_tree()
	_force_redraw()


func _on_delete_node_requested(node_to_delete: TreeVisualizerGraphNode) -> void:
	_disable_graph_edit_action_buttons()

	if not Engine.is_editor_hint():
		push_warning("Node deletion via action button is permitted only in editor mode.")
		return

	if not node_to_delete:
		push_warning("Delete node request is missing target graph node.")
		return

	var scene_node = node_to_delete.node
	node_to_delete.queue_free()
	scene_node.queue_free()
	_selected_node = null

	_force_redraw()


func _on_tree_loaded(tree: SenseTree) -> void:
	_selected_tree = tree
	_graph_edit.save_tree_button.selected_tree = tree
	_graph_edit.save_tree_as_button.selected_tree = tree
	_reset_elements()
