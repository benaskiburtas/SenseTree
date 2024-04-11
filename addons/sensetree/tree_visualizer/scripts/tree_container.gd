@tool
class_name TreeVisualizerContainer
extends Container

const DEFAULT_HASH = HashingContext.HASH_MD5
const IDLE_POLL_RATE: int = 30
const PHYSICS_POLL_RATE: int = 30

var _process_mode: SenseTreeConstants.ProcessMode = SenseTreeConstants.ProcessMode.PHYSICS
var _hashing_context: HashingContext
var _previous_scene_hash: PackedByteArray
var _current_idle_tick_count: int = 0
var _current_physics_tick_count: int = 0

@onready var _graph_edit: TreeVisualizerGraphEdit = $TreeGraphEditor
@onready
var _tree_list_vertical_box: VBoxContainer = $TreeList/TreeListMarginContainer/TreeListVerticalBox


func _enter_tree() -> void:
	_hashing_context = HashingContext.new()


func _ready() -> void:
	_setup_process_mode()
	_populate_buttons([])
	_graph_edit.connect("node_selected", _on_node_selected)


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
	else:
		var trees = sense_nodes.filter(func(node): return node is SenseTree)
		_clear_ui()
		_populate_buttons(trees)


func _setup_process_mode() -> void:
	set_process(_process_mode == SenseTreeConstants.ProcessMode.IDLE)
	set_physics_process(_process_mode == SenseTreeConstants.ProcessMode.PHYSICS)


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


func _clear_ui() -> void:
	_graph_edit.clear_connections()
	for child in _graph_edit.get_children():
		child.queue_free()
	for child in _tree_list_vertical_box.get_children():
		child.queue_free()


func _populate_buttons(scene_trees: Array) -> void:
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


func _on_tree_selected(tree: SenseTree) -> void:
	_graph_edit.assign_new_tree(tree)


func _on_node_selected(selected_node: Node) -> void:
	# Exit early if running not in-editor
	if not Engine.is_editor_hint():
		return
	
	if not selected_node is TreeVisualizerGraphNode:
		return
		
	var sense_graph_node = selected_node as TreeVisualizerGraphNode
	var scene_node = sense_graph_node._scene_node
	
	# Select matching node in scene list
	var scene_selector: EditorSelection = EditorInterface.get_selection()
	scene_selector.clear()
	scene_selector.add_node(scene_node)
	
	
	
