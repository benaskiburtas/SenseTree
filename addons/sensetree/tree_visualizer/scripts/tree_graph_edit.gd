@tool
class_name TreeVisualizerGraphEdit
extends GraphEdit

const IDLE_MODE_REDRAW_RATE: int = 150
const PHYSICS_MODE_REDRAW_RATE: int = 150

const GraphNodeStyleBoxes = preload(
	"res://addons/sensetree/tree_visualizer/scripts/graphnode_styleboxes.gd"
)
const GraphNodeArranger = preload(
	"res://addons/sensetree/tree_visualizer/scripts/tree_node_arranger.gd"
)

var style_boxes: TreeVisualizerGraphNodeStyleBoxes

var _process_mode: SenseTreeConstants.ProcessMode
var _ticks_since_redraw: int = 0
var _is_graph_being_updated: bool = false


func _init(process_mode: SenseTreeConstants.ProcessMode = SenseTreeConstants.ProcessMode.PHYSICS):
	_process_mode = process_mode
	minimap_enabled = false
	style_boxes = GraphNodeStyleBoxes.new()


func _ready():
	_set_process_modes()
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
	pass


func _get_connection_line(from_position: Vector2, to_position: Vector2) -> PackedVector2Array:
	var line_points: PackedVector2Array
	line_points.push_back(from_position)
	line_points.push_back(Vector2(from_position.x, to_position.y))
	line_points.push_back(to_position)
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
