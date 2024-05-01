@tool
class_name TreeVisualizerContainer
extends Container

const DEFAULT_HASH = HashingContext.HASH_MD5
const IDLE_POLL_RATE: int = 100
const PHYSICS_POLL_RATE: int = 100

const TreeFileManager: Resource = preload(
	"res://addons/sensetree/tree_visualizer/node/tree_file_manager.gd"
)

var _process_mode: SenseTreeConstants.ProcessMode = SenseTreeConstants.ProcessMode.PHYSICS

var _hashing_context: HashingContext
var _previous_scene_hash: PackedByteArray

var _selected_tree: SenseTree
var _selected_node: TreeVisualizerGraphNode

var _current_idle_tick_count: int = 0
var _current_physics_tick_count: int = 0

var _file_manager: TreeVisualizerFileManager
var _graph_edit: TreeVisualizerGraphEdit


func _init():
	_hashing_context = HashingContext.new()


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
		_graph_edit.add_node_button.connect("create_node_requested", _on_create_node_requested)
		_graph_edit.rename_node_button.connect("rename_node_requested", _on_rename_node_requested)
		_graph_edit.delete_node_button.connect("delete_node_requested", _on_delete_node_requested)


func _connect_file_manager_signals() -> void:
	_file_manager.connect("tree_loaded", _on_tree_loaded)


func _force_redraw() -> void:
	_current_idle_tick_count = IDLE_POLL_RATE + 1
	_current_physics_tick_count = PHYSICS_POLL_RATE + 1
	_process_frame(_process_mode)


func _is_update_needed(nodes: Array) -> bool:
	if not _selected_tree:
		return true

	var current_scene_hash = _generate_sense_nodes_hash(nodes)
	print(current_scene_hash)
	if current_scene_hash != _previous_scene_hash:
		_previous_scene_hash = current_scene_hash
		return true
	return false


func _generate_sense_nodes_hash(sense_nodes: Array) -> PackedByteArray:
	if not _nodes_valid_for_hashing(sense_nodes):
		return PackedByteArray()

	_hashing_context.start(DEFAULT_HASH)
	for node in sense_nodes:
		var node_identifier = "[%s %s]" % [node.name, inst_to_dict(node)]
		node_identifier = _remove_objectid_identifiers(node_identifier)
		_hashing_context.update(node_identifier.to_utf8_buffer())
	var finish = _hashing_context.finish()
	return finish


func _remove_objectid_identifiers(node_identifier: String) -> String:
	var regex = RegEx.new()
	regex.compile("#\\d+")
	return regex.sub(node_identifier, "", true)


func _nodes_valid_for_hashing(sense_nodes: Array) -> bool:
	if sense_nodes.is_empty():
		return false

	var invalid_nodes = sense_nodes.filter(func(node): not (node is SenseTreeNode))

	var error_lines = []
	for node in invalid_nodes:
		error_lines.append("[Name: %s, Type: %s]\n" % [node.name, node.get_class()])

	if not error_lines.is_empty():
		var final_error_message = (
			"Expected SenseTreeNodes for generating tree visualizer hash, found invalid nodes:\n"
			+ "".join(error_lines)
		)
		push_error(final_error_message)
		return false

	return true


func _reset_elements() -> void:
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

	if not selected_node.scene_node:
		push_warning(
			"SenseTree Visualizer Warning: Cannot match in-editor node selection as scene node is missing."
		)
		return

	var node_name = selected_node.scene_node.name

	# Select matching node in scene list
	var scene_root: Node = EditorInterface.get_edited_scene_root()

	var scene_node: Node
	if scene_root and scene_root.name == node_name:
		scene_node = scene_root
	else:
		scene_node = scene_root.find_child(node_name, true)

	if not scene_node:
		return

	var scene_selector: EditorSelection = EditorInterface.get_selection()
	scene_selector.clear()
	scene_selector.add_node(scene_node)


func _disable_graph_edit_action_buttons() -> void:
	_graph_edit.add_node_button.selected_node = null
	_graph_edit.delete_node_button.selected_node = null
	_graph_edit.rename_node_button.selected_node = null


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
	_graph_edit.rename_node_button.selected_node = selected_node


func _on_node_deselected(deselected_node: Node) -> void:
	# Exit early if running not in-editor
	if not Engine.is_editor_hint():
		return
	_disable_graph_edit_action_buttons()


func _on_new_tree_requested() -> void:
	_file_manager.new_tree()


func _on_load_tree_requested() -> void:
	_file_manager.load_tree()


func _on_save_tree_requested(tree: SenseTree) -> void:
	_file_manager.save_tree(tree)


func _on_create_node_requested(node_class: String) -> void:
	_disable_graph_edit_action_buttons()

	if not Engine.is_editor_hint():
		push_warning("Node creation via action button is permitted only in editor mode.")
		return

	if not _selected_node:
		push_warning("Cannot instantiate new node as no selected node was found.")
		return

	var node_script_path = SenseTreeHelpers.try_acquire_script_path(node_class)
	if not node_script_path:
		push_warning("Could not resolve script path for SenseTree node %s." % node_class)
		return

	var scene_node = _selected_node.scene_node
	var node_script: Script = load(node_script_path)
	var new_node_instance: SenseTreeNode = node_script.new()

	new_node_instance.set_name(node_class)
	scene_node.add_child(new_node_instance, true)
	new_node_instance.set_owner(scene_node)
	
	_file_manager.auto_save_tree()
	_force_redraw()


func _on_rename_node_requested(node: TreeVisualizerGraphNode) -> void:
	print("on_rename_node_requested reached tree container")


func _on_delete_node_requested(node: TreeVisualizerGraphNode) -> void:
	_disable_graph_edit_action_buttons()

	if not Engine.is_editor_hint():
		push_warning("Node deletion via action button is permitted only in editor mode.")
		return

	if not node:
		push_warning("Delete node request is missing target graph node.")
		return

	var scene_node = node.scene_node
	node.queue_free()
	scene_node.queue_free()
	_selected_node = null

	_force_redraw()


func _on_tree_loaded(tree: SenseTree) -> void:
	var sense_nodes = _get_tree_sense_nodes(tree)
	if not _is_update_needed(sense_nodes):
		return

	if _selected_tree:
		_selected_tree.queue_free()
	_selected_tree = tree

	_graph_edit.save_tree_button.selected_tree = tree

	_reset_elements()
