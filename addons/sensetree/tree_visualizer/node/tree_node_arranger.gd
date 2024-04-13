## https://www.researchgate.net/publication/30508504_Improving_Walker's_Algorithm_to_Run_in_Linear_Time
## https://llimllib.github.io/pymag-trees/
@tool
class_name ArrangedVisualizerNode
extends Node

const DEFAULT_DISTANCE: float = 1.0

var x: float = -1.
var y: int = 0
var tree: SenseTreeNode
var children: Array = []
var parent: ArrangedVisualizerNode
var ancestor: ArrangedVisualizerNode
var thread: ArrangedVisualizerNode
var offset_modifier: float = 0.0
var change: float = 0.0
var shift: float = 0.0
var sibling_order_number: int = 1
var leftmost_sibling: ArrangedVisualizerNode:
	get:
		if not leftmost_sibling and parent and self != parent.children[0]:
			leftmost_sibling = parent.children[0]
		return leftmost_sibling


func _init(
	tree: SenseTreeNode,
	parent: ArrangedVisualizerNode = null,
	depth: int = 0,
	sibling_order_number: int = 1
):
	self.y = depth
	self.tree = tree
	self.parent = parent
	self.ancestor = self
	self.sibling_order_number = sibling_order_number

	for i in range(tree.get_child_count()):
		var child = tree.get_child(i)
		children.append(ArrangedVisualizerNode.new(child, self, depth + 1, i + 1))


func is_leaf() -> bool:
	return children.is_empty()


func boundaries() -> Array:
	var bounds = [self.x, self.x, self.y, self.y]
	for child in children:
		bounds = update_bounds(bounds, child.boundaries())
	return bounds


func update_bounds(bounds: Array, child_bounds: Array) -> Array:
	return [
		min(bounds[0], child_bounds[0]),
		max(bounds[1], child_bounds[1]),
		min(bounds[2], child_bounds[2]),
		max(bounds[3], child_bounds[3])
	]


func next_left() -> ArrangedVisualizerNode:
	if is_leaf():
		return thread
	else:
		return children[0]


func next_right() -> ArrangedVisualizerNode:
	if is_leaf():
		return thread
	else:
		return children[-1]


func left_brother() -> ArrangedVisualizerNode:
	var previous_sibling: ArrangedVisualizerNode = null
	if parent:
		for current_sibling in parent.children:
			if current_sibling == self:
				return previous_sibling
			else:
				previous_sibling = current_sibling
	return previous_sibling


func is_leftmost_sibling() -> bool:
	if parent:
		return self == parent.children[0]
	return false


func buchheim(tree: ArrangedVisualizerNode) -> Array:
	first_walk(tree)
	if tree.offset_modifier != 0:
		push_error("Encountered non-zero tree.offset_modifier while arranging tree")
		return []
	second_walk(tree, 0 - tree.offset_modifier)
	return tree.boundaries()


func first_walk(node: ArrangedVisualizerNode):
	if node.is_leaf():
		if node.is_leftmost_sibling():
			node.x = 0.0
		else:
			if node.left_brother():
				node.x = node.left_brother().x + DEFAULT_DISTANCE
	else:
		var default_ancestor: ArrangedVisualizerNode = node.children[0]
		for child in node.children:
			first_walk(child)
			default_ancestor = apportion(child, default_ancestor)

		execute_shifts(node)

		var midpoint: float = (node.children[0].x + node.children[-1].x) / 2.0

		var left_brother: ArrangedVisualizerNode = node.left_brother()
		if left_brother:
			node.x = left_brother.x + DEFAULT_DISTANCE
			node.offset_modifier = node.x - midpoint
		else:
			node.x = midpoint


func apportion(
	node: ArrangedVisualizerNode, default_ancestor: ArrangedVisualizerNode
) -> ArrangedVisualizerNode:
	var left_sibling: ArrangedVisualizerNode = node.left_brother()
	if left_sibling:
		var inner_right: ArrangedVisualizerNode = node
		var inner_left: ArrangedVisualizerNode = node
		var inner_left_sibling: ArrangedVisualizerNode = left_sibling
		var outer_left: ArrangedVisualizerNode = node.leftmost_sibling
		var inner_right_offset: float = node.offset_modifier
		var inner_left_offset: float = inner_left_sibling.offset_modifier
		var outer_left_offset: float = outer_left.offset_modifier
		var outer_right_offset: float = node.leftmost_sibling.offset_modifier

		while inner_left_sibling.next_right() and inner_right.next_left():
			inner_left_sibling = inner_left_sibling.next_right()
			inner_right = inner_right.next_left()
			outer_left = outer_left.next_left()
			inner_left = inner_left.next_right()
			inner_left.ancestor = node

			var shift: float = (
				(inner_left_sibling.x + inner_left_offset)
				- (inner_right.x + inner_right_offset)
				+ DEFAULT_DISTANCE
			)
			if shift > 0:
				var ancestor: ArrangedVisualizerNode = get_ancestor(
					inner_left_sibling, node, default_ancestor
				)
				move_subtree(ancestor, node, shift)
				inner_right_offset += shift
				outer_right_offset += shift

			inner_left_offset += inner_left_sibling.offset_modifier
			inner_right_offset += inner_right.offset_modifier
			outer_left_offset += outer_left.offset_modifier
			outer_right_offset += inner_left.offset_modifier

		if inner_left_sibling.next_right() and not inner_left.next_right():
			inner_left.thread = inner_left_sibling.next_right()
			inner_left.offset_modifier += inner_left_offset - outer_right_offset
		else:
			if inner_right.next_left() and not outer_left.next_left():
				outer_left.thread = inner_right.next_left()
				outer_left.offset_modifier += inner_right_offset - outer_left_offset

		default_ancestor = node

	return default_ancestor


func move_subtree(
	left_node: ArrangedVisualizerNode, right_node: ArrangedVisualizerNode, shift_amount: float
):
	var subtree_count: int = right_node.sibling_order_number - left_node.sibling_order_number
	var shift_per_subtree: float = shift_amount / subtree_count
	right_node.change -= shift_per_subtree
	left_node.change += shift_per_subtree
	right_node.shift += shift_amount
	right_node.x += shift_amount
	right_node.offset_modifier += shift_amount


func execute_shifts(node: ArrangedVisualizerNode):
	var shift: float = 0.0
	var change: float = 0.0
	for child in node.children:
		child.x += shift
		child.offset_modifier += shift
		change += child.change
		shift += child.shift + change


func get_ancestor(
	inner_left_node: ArrangedVisualizerNode,
	node: ArrangedVisualizerNode,
	default_ancestor: ArrangedVisualizerNode
) -> ArrangedVisualizerNode:
	if inner_left_node.ancestor in node.parent.children:
		return inner_left_node.ancestor
	else:
		return default_ancestor


func second_walk(node: ArrangedVisualizerNode, modifier: float = 0.0):
	for child in node.children:
		second_walk(child, modifier + node.offset_modifier)
	node.x += modifier
