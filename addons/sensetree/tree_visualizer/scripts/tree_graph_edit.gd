@tool
class_name TreeVisualizerGraphEdit
extends GraphEdit

const IDLE_MODE_REDRAW_RATE: int = 300
const PHYSICS_MODE_REDRAW_RATE: int = 300

const GraphNodeStyleBoxes = preload(
	"res://addons/sensetree/tree_visualizer/scripts/graphnode_styleboxes.gd"
)
const GraphNodeArranger = preload("res://addons/sensetree/tree_visualizer/scripts/tree_node_arranger.gd")

var style_boxes: TreeVisualizerGraphNodeStyleBoxes

var _process_mode: SenseTreeConstants.ProcessMode
var _ticks_since_redraw: int = 0
var _is_graph_being_updated: bool = false


func _init(process_mode: SenseTreeConstants.ProcessMode = SenseTreeConstants.ProcessMode.PHYSICS):
	_process_mode = process_mode
	minimap_enabled = false
	style_boxes = GraphNodeStyleBoxes.new()

func _ready():
	set_process(_process_mode == SenseTreeConstants.ProcessMode.IDLE)
	set_physics_process(_process_mode == SenseTreeConstants.ProcessMode.PHYSICS)

func _process(delta) -> void:
	_process_draw(SenseTreeConstants.ProcessMode.IDLE)


func _physics_process(delta) -> void:
	_process_draw(SenseTreeConstants.ProcessMode.PHYSICS)


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


func assign_new_tree(tree: SenseTree) -> void:
	if _is_graph_being_updated:
		push_warning("Behavior tree is currently being updated, tree cannot be re-assigned")
		return
	
	_is_graph_being_updated = true
	clear_connections()
	_remove_graph_nodes()

	if tree and tree.has_children:
		_build_new_graph(tree)
	
	_is_graph_being_updated = false

func _remove_graph_nodes() -> void:
	for graph in get_children():
		graph.queue_free()


func _build_new_graph(tree: SenseTreeNode) -> void:
	if not tree.has_children:
		push_warning(
			"Behavior tree is empty and graph view cannot be drawn. Is it configured properly?"
		)
		return
	
	var arranged_tree_root = GraphNodeArranger.new(tree)
	arranged_tree_root.buchheim(arranged_tree_root)
	
	var tree_stack = [arranged_tree_root]
	while not tree_stack.is_empty():
		var arranged_node = tree_stack.pop_back()
		var graph_node = TreeVisualizerGraphNode.new(arranged_node, style_boxes)
		add_child(graph_node)

		var node_children: Array = arranged_node.children.duplicate()
		node_children.reverse()

		for child in node_children:
			tree_stack.push_back(child)
