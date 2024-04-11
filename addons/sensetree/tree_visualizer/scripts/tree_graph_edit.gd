@tool
class_name TreeVisualizerGraphEdit
extends GraphEdit

const GraphNodeStyleBoxes = preload(
	"res://addons/sensetree/tree_visualizer/scripts/graphnode_styleboxes.gd"
)
const GraphNodeArranger = preload("res://addons/sensetree/tree_visualizer/scripts/tree_node_arranger.gd")

var style_boxes: TreeVisualizerGraphNodeStyleBoxes

var _is_graph_being_updated: bool = false


func _init():
	minimap_enabled = false
	style_boxes = GraphNodeStyleBoxes.new()


func assign_new_tree(tree: SenseTree) -> void:
	if _is_graph_being_updated:
		push_warning("Behavior tree is currently being updated, tree cannot be re-assigned")
		return
	else:
		clear_connections()
		_remove_graph_nodes()

	if tree and tree.has_children:
		_build_new_graph(tree)

func _remove_graph_nodes() -> void:
	for graph in get_children():
		graph.queue_free()


func _build_new_graph(tree: SenseTreeNode) -> void:
	pass
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
			
