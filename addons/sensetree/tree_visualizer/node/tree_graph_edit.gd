@tool
class_name TreeVisualizerGraphEdit
extends GraphEdit

const IDLE_MODE_REDRAW_RATE: int = 150
const PHYSICS_MODE_REDRAW_RATE: int = 150

const GraphNodeStyleBoxes: Resource = preload(
	"res://addons/sensetree/tree_visualizer/resource/tree_graph_node_style_boxes.gd"
)
const GraphNodeArranger: Script = preload(
	"res://addons/sensetree/tree_visualizer/node/tree_node_arranger.gd"
)

const NewTreeButton: Script = preload(
	"res://addons/sensetree/tree_visualizer/node/tree_action/new_tree_button.gd"
)
const LoadTreeButton: Script = preload(
	"res://addons/sensetree/tree_visualizer/node/tree_action/load_tree_button.gd"
)
const SaveTreeButton: Script = preload(
	"res://addons/sensetree/tree_visualizer/node/tree_action/save_tree_button.gd"
)
const AddNodeButton: Script = preload(
	"res://addons/sensetree/tree_visualizer/node/node_action/add_node_button.gd"
)
const RenameNodeButton: Script = preload(
	"res://addons/sensetree/tree_visualizer/node/node_action/rename_node_button.gd"
)
const DeleteNodeButton: Script = preload(
	"res://addons/sensetree/tree_visualizer/node/node_action/delete_node_button.gd"
)

var style_boxes: TreeVisualizerGraphNodeStyleBoxes

var new_tree_button: TreeVisualizeNewTreeButton = null
var load_tree_button: TreeVisualizeLoadTreeButton = null
var save_tree_button: TreeVisualizeSaveTreeButton = null
var add_node_button: TreeVisualizerAddNodeButton = null
var rename_node_button: TreeVisualizeRenameNodeButton = null
var delete_node_button: TreeVisualizerDeleteNodeButton = null

var _process_mode: SenseTreeConstants.ProcessMode = SenseTreeConstants.ProcessMode.PHYSICS
var _ticks_since_redraw: int = 0
var _is_graph_being_updated: bool = false


func _init():
	minimap_enabled = false
	style_boxes = GraphNodeStyleBoxes.new()


func _ready():
	_set_process_modes()
	# Scene editing is only allowed while scene is not running
	if Engine.is_editor_hint():
		_add_additional_action_buttons()


func _process(delta: float) -> void:
	_process_draw(SenseTreeConstants.ProcessMode.IDLE)


func _physics_process(delta: float) -> void:
	_process_draw(SenseTreeConstants.ProcessMode.PHYSICS)


func _set_process_modes() -> void:
	# Needed to stop constant re-rendering of the graph. Performance issues on complex graphs
	OS.low_processor_usage_mode = true

	set_process(_process_mode == SenseTreeConstants.ProcessMode.IDLE)
	set_physics_process(_process_mode == SenseTreeConstants.ProcessMode.PHYSICS)


func _add_additional_action_buttons() -> void:
	var toolbar = get_menu_hbox()
	
	new_tree_button = NewTreeButton.new()
	toolbar.add_child(new_tree_button)

	load_tree_button = LoadTreeButton.new()
	toolbar.add_child(load_tree_button)

	save_tree_button = SaveTreeButton.new()
	toolbar.add_child(save_tree_button)
	
	# Separate tree actions and node actions
	toolbar.add_spacer(false)

	add_node_button = AddNodeButton.new()
	toolbar.add_child(add_node_button)

	rename_node_button = RenameNodeButton.new()
	toolbar.add_child(rename_node_button)

	delete_node_button = DeleteNodeButton.new()
	toolbar.add_child(delete_node_button)


func _get_connection_line(from_position: Vector2, to_position: Vector2) -> PackedVector2Array:
	var line_points: PackedVector2Array

	var middle_x = (from_position.x + to_position.x) / 2
	var middle_y = (from_position.y + to_position.y) / 2
	var middle = Vector2(middle_x, middle_y)

	line_points.push_back(Vector2(from_position.x, from_position.y))
	line_points.push_back(Vector2(middle.x, from_position.y))
	line_points.push_back(Vector2(middle.x, middle.y))
	line_points.push_back(Vector2(middle.x, to_position.y))
	line_points.push_back(Vector2(to_position.x, to_position.y))

	return line_points


func _process_draw(mode: SenseTreeConstants.ProcessMode) -> void:
	match mode:
		SenseTreeConstants.ProcessMode.IDLE:
			_ticks_since_redraw += 1
			if _ticks_since_redraw >= IDLE_MODE_REDRAW_RATE:
				_ticks_since_redraw = 0
			else:
				return
		SenseTreeConstants.ProcessMode.PHYSICS:
			_ticks_since_redraw += 1
			if _ticks_since_redraw >= PHYSICS_MODE_REDRAW_RATE:
				_ticks_since_redraw = 0
			else:
				return

	queue_redraw()


func assign_tree(tree: SenseTree) -> void:
	if _is_graph_being_updated:
		push_warning("Behavior tree is currently being updated, tree cannot be re-assigned")
		return
	_is_graph_being_updated = true

	clear_connections()
	_remove_graph_nodes()

	if tree and tree.has_children:
		_draw_new_tree(tree)

	_is_graph_being_updated = false


func reset() -> void:
	_is_graph_being_updated = true
	clear_connections()
	_remove_graph_nodes()
	_is_graph_being_updated = false


func _remove_graph_nodes() -> void:
	for graph in get_children():
		graph.queue_free()


func _draw_new_tree(tree: SenseTreeNode) -> void:
	if not tree.has_children:
		push_warning(
			"Behavior tree is empty and graph view cannot be drawn. Is it configured properly?"
		)
		return

	var arranged_tree: ArrangedVisualizerNode = _arrange_tree(tree)
	_place_arranged_tree(arranged_tree)


func _arrange_tree(tree: SenseTree) -> ArrangedVisualizerNode:
	var arranged_tree_root = GraphNodeArranger.new(tree)
	arranged_tree_root.buchheim(arranged_tree_root)
	return arranged_tree_root


func _place_arranged_tree(arranged_tree: ArrangedVisualizerNode):
	var tree_stack = [GraphNodeDetails.new(arranged_tree, null)]

	while not tree_stack.is_empty():
		var node_details: GraphNodeDetails = tree_stack.pop_back()
		var arranged_node = node_details.node
		var parent_node = node_details.parent

		var graph_node = TreeVisualizerGraphNode.new(arranged_node, style_boxes)
		add_child(graph_node)

		if parent_node:
			connect_node(parent_node.name, 0, graph_node.name, 0)

		var node_children: Array = arranged_node.children.duplicate()
		node_children.reverse()
		for child in node_children:
			tree_stack.push_back(GraphNodeDetails.new(child, graph_node))


class GraphNodeDetails:
	var node: ArrangedVisualizerNode
	var parent: TreeVisualizerGraphNode

	func _init(_node: ArrangedVisualizerNode, _parent: TreeVisualizerGraphNode):
		node = _node
		parent = _parent
