@tool
class_name SenseTreeVisualizerContainer
extends Container

const DEFAULT_PROCESS_MODE = SenseTreeConstants.TickProcessMode.PHYSICS
const IDLE_POLL_RATE: int = 60
const PHYSICS_POLL_RATE: int = 60

var _process_mode: SenseTreeConstants.TickProcessMode = DEFAULT_PROCESS_MODE
var _hashing_context: HashingContext
var _previous_tree_hash: PackedByteArray
var _current_idle_tick_count: int = 0
var _current_physics_tick_count: int = 0

@onready var _graph_edit: SenseTreeVisualizerGraphEdit = $TreeGraphEditor
@onready
var _tree_list_vertical_box: VBoxContainer = $TreeList/TreeListMarginContainer/TreeListVerticalBox


func _enter_tree() -> void:
	_resolve_process_mode()
	_hashing_context = HashingContext.new()


func _ready() -> void:
	_populate_buttons([])


func _process(delta) -> void:
	_process_frame(SenseTreeConstants.TickProcessMode.IDLE)


func _physics_process(delta) -> void:
	_process_frame(SenseTreeConstants.TickProcessMode.PHYSICS)


func _process_frame(mode: SenseTreeConstants.TickProcessMode) -> void:
	match mode:
		SenseTreeConstants.TickProcessMode.IDLE:
			_current_idle_tick_count += 1
			if _current_idle_tick_count >= IDLE_POLL_RATE:
				_current_idle_tick_count = 0
			else:
				return
		SenseTreeConstants.TickProcessMode.PHYSICS:
			_current_physics_tick_count += 1
			if _current_physics_tick_count >= PHYSICS_POLL_RATE:
				_current_physics_tick_count = 0
			else:
				return

	var sense_nodes = _get_scene_sense_nodes()
	if not _is_update_needed(sense_nodes):
		return
	else:
		var trees = sense_nodes.filter(func(node): node is SenseTree)
		_clear_ui()
		_populate_buttons(trees)


func _resolve_process_mode() -> void:
	set_process(_process_mode == SenseTreeConstants.TickProcessMode.IDLE)
	set_physics_process(_process_mode == SenseTreeConstants.TickProcessMode.PHYSICS)


func _is_update_needed(scene_trees: Array) -> bool:
	var current_tree_hash = _generate_tree_hash(scene_trees)

	if current_tree_hash != _previous_tree_hash:
		_previous_tree_hash = current_tree_hash
		return true
	return false


func _generate_tree_hash(tree_members: Array) -> PackedByteArray:
	if tree_members.is_empty():
		return PackedByteArray()
	_hashing_context.start(HashingContext.HASH_MD5)
	_hashing_context.update(tree_members)
	return _hashing_context.finish()


func _clear_ui() -> void:
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
		var button = SenseTreeEditorSelectButton.new(tree)
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
	_graph_edit._build_structure_from_tree(tree)
