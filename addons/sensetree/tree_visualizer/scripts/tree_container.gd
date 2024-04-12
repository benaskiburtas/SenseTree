@tool
class_name TreeVisualizerContainer
extends Container

const DEFAULT_HASH = HashingContext.HASH_MD5
const IDLE_POLL_RATE: int = 15
const PHYSICS_POLL_RATE: int = 15

var _process_mode: SenseTreeConstants.ProcessMode = SenseTreeConstants.ProcessMode.PHYSICS
var _hashing_context: HashingContext
var _previous_scene_hash: PackedByteArray
var _selected_tree: SenseTree
var _selected_node: TreeVisualizerGraphNode
var _current_idle_tick_count: int = 0
var _current_physics_tick_count: int = 0

@onready var _graph_edit: TreeVisualizerGraphEdit = $TreeGraphEditor
@onready
var _tree_list_vertical_box: VBoxContainer = $TreeList/TreeListMarginContainer/TreeListVerticalBox


func _enter_tree() -> void:
	_hashing_context = HashingContext.new()


func _ready() -> void:
	_setup_process_mode()
	_connect_graph_edit_signals()
	_populate_tree_selection_buttons([])


func _process(delta) -> void:
	_process_frame(SenseTreeConstants.ProcessMode.IDLE)


func _physics_process(delta) -> void:
	_process_frame(SenseTreeConstants.ProcessMode.PHYSICS)


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

	var sense_nodes = _get_scene_sense_nodes()

	if not _is_update_needed(sense_nodes):
		return

	if _selected_tree not in sense_nodes:
		_selected_tree = null

	var trees = sense_nodes.filter(func(node): return node is SenseTree)
	_reset_elements()
	_populate_tree_selection_buttons(trees)


func _setup_process_mode() -> void:
	set_process(_process_mode == SenseTreeConstants.ProcessMode.IDLE)
	set_physics_process(_process_mode == SenseTreeConstants.ProcessMode.PHYSICS)


func _connect_graph_edit_signals() -> void:
	_graph_edit.connect("node_selected", _on_node_selected)
	_graph_edit.connect("node_deselected", _on_node_deselected)
	if Engine.is_editor_hint():
		_graph_edit.add_node_button.connect("create_node_requested", _on_create_node_requested)


func _is_update_needed(nodes: Array) -> bool:
	var current_scene_hash = _generate_scene_sense_nodes_hash(nodes)

	if current_scene_hash != _previous_scene_hash:
		_previous_scene_hash = current_scene_hash
		return true
	return false


func _generate_scene_sense_nodes_hash(sense_nodes: Array) -> PackedByteArray:
	if not _nodes_valid_for_hashing(sense_nodes):
		return PackedByteArray()

	_hashing_context.start(DEFAULT_HASH)
	for node in sense_nodes:
		var node_identifier = "[%s %s]" % [node.name, inst_to_dict(node)]
		_hashing_context.update(node_identifier.to_utf8_buffer())
	var finish = _hashing_context.finish()
	return finish


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
	for child in _tree_list_vertical_box.get_children():
		child.queue_free()

	if _selected_tree:
		_graph_edit.assign_tree(_selected_tree)
	else:
		_graph_edit.reset()


func _populate_tree_selection_buttons(scene_trees: Array) -> void:
	var scene: Node
	if Engine.is_editor_hint():
		scene = get_tree().edited_scene_root
	else:
		scene = get_tree().current_scene

	for tree in scene_trees:
		var button = TreeVisualizerSelectButton.new(tree)
		button.connect("tree_selected", _on_tree_selected)
		_tree_list_vertical_box.add_child(button)


func _get_scene_sense_nodes() -> Array:
	var scene: Node
	if Engine.is_editor_hint():
		scene = get_tree().edited_scene_root
	else:
		scene = get_tree().current_scene

	return _find_all_sense_nodes(scene)


func _find_all_sense_nodes(node: Node) -> Array:
	var result = []
	if node is SenseTreeNode:
		result.append(node)

	if node:
		for child in node.get_children():
			result.append_array(_find_all_sense_nodes(child))

	return result


func _select_node_in_editor(selected_node: TreeVisualizerGraphNode) -> void:
	var scene_node = selected_node.scene_node

	# Select matching node in scene list
	var scene_selector: EditorSelection = EditorInterface.get_selection()
	scene_selector.clear()
	scene_selector.add_node(scene_node)


func _on_tree_selected(tree: SenseTree) -> void:
	_selected_tree = tree
	_graph_edit.assign_tree(tree)


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
	_graph_edit.add_node_button.selected_node = null
	_graph_edit.delete_node_button.selected_node = null


func _on_create_node_requested(node_class: String) -> void:
	if not Engine.is_editor_hint():
		push_warning("Node creation via action button works only in editor mode.")
		return
	if not _selected_node:
		push_warning("Cannot instantiate new node as no selected node is found.")
		return
	
	var node_script_path = SenseTreeHelpers.try_acquire_script_path(node_class)
	if not node_script_path:
		push_warning("Could not resolve script path for SenseTree node %s" % node_class)
		return
		
	var node_resource: Script = load(node_script_path)
	var node_instance: SenseTreeNode = node_resource.new()
	node_instance.set_name(node_class)
	_selected_node.scene_node.add_child(node_instance, true)
