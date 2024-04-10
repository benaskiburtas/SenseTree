@tool
class_name TreeVisualizerGraphEdit
extends GraphEdit

const GraphNodeStyleBoxes = preload(
	"res://addons/sensetree/tree_visualizer/scripts/graphnode_styleboxes.gd"
)

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

	var node_stack = []
	node_stack.push_back(tree)

	while not node_stack.is_empty():
		var node = node_stack.pop_back()

		var graph_node = TreeVisualizerGraphNode.new(node, style_boxes)
		add_child(graph_node)

		var node_children: Array = node.get_children().duplicate()
		node_children.reverse()

		for child in node_children:
			node_stack.push_back(child)
