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
var _leftmost_sibling: ArrangedVisualizerNode
var leftmost_sibling: ArrangedVisualizerNode:
	get:
		if not _leftmost_sibling and parent and self != parent.children[0]:
			_leftmost_sibling = parent.children[0]
		return _leftmost_sibling


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
	var minx: float = self.x
	var maxx: float = self.x
	var miny: float = self.y
	var maxy: float = self.y
	for child in children:
		var child_bounds = child.boundaries_([minx, maxx, miny, maxy])
		minx = min(minx, child_bounds[0])
		miny = min(miny, child_bounds[2])
		maxx = max(maxx, child_bounds[1])
		maxy = max(maxy, child_bounds[3])
	return [minx, maxx, miny, maxy]


func boundaries_(bounds: Array) -> Array:
	if is_leaf():
		bounds[0] = min(bounds[0], self.x)
		bounds[2] = min(bounds[2], self.y)
		bounds[1] = max(bounds[1], self.x)
		bounds[3] = max(bounds[3], self.y)
	else:
		for child in children:
			bounds = child.boundaries_(bounds)
	return bounds


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
	var n: ArrangedVisualizerNode = null
	if parent:
		for node in parent.children:
			if node == self:
				return n
			else:
				n = node
	return n


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


func first_walk(v: ArrangedVisualizerNode):
	if v.is_leaf():
		if v.is_leftmost_sibling():
			v.x = 0.0
		else:
			v.x = v.left_brother().x + DEFAULT_DISTANCE
	else:
		var default_ancestor = v.children[0]
		for w in v.children:
			first_walk(w)
			default_ancestor = apportion(w, default_ancestor)

		execute_shifts(v)

		var midpoint = (v.children[0].x + v.children[-1].x) / 2.0

		var w = v.left_brother()
		if w:
			v.x = w.x + DEFAULT_DISTANCE
			v.offset_modifier = v.x - midpoint
		else:
			v.x = midpoint


func apportion(
	v: ArrangedVisualizerNode, default_ancestor: ArrangedVisualizerNode) -> ArrangedVisualizerNode:
	var w = v.left_brother()
	if w:
		var vir = v
		var vor = v
		var vil = w
		var vol = v.leftmost_sibling
		var sir = v.offset_modifier
		var sil = vil.offset_modifier
		var sol = vol.offset_modifier
		var sor = v.leftmost_sibling.offset_modifier
		while vil.next_right() and vir.next_left():
			vil = vil.next_right()
			vir = vir.next_left()
			vol = vol.next_left()
			vor = vor.next_right()
			vor.ancestor = v
			var shift = (vil.x + sil) - (vir.x + sir) + DEFAULT_DISTANCE
			if shift > 0:
				var a = get_ancestor(vil, v, default_ancestor)
				move_subtree(a, v, shift)
				sir += shift
				sor += shift
			sil += vil.offset_modifier
			sir += vir.offset_modifier
			sol += vol.offset_modifier
			sor += vor.offset_modifier
		if vil.next_right() and not vor.next_right():
			vor.thread = vil.next_right()
			vor.offset_modifier += sil - sor
		else:
			if vir.next_left() and not vol.next_left():
				vol.thread = vir.next_left()
				vol.offset_modifier += sir - sol
		default_ancestor = v
	return default_ancestor


func move_subtree(wl: ArrangedVisualizerNode, wr: ArrangedVisualizerNode, shift: float):
	var subtrees = wr.sibling_order_number - wl.sibling_order_number
	var shift_by_subtrees = shift / subtrees
	wr.change -= shift_by_subtrees
	wl.change += shift_by_subtrees
	wr.shift += shift
	wr.x += shift
	wr.offset_modifier += shift


func execute_shifts(v: ArrangedVisualizerNode):
	var shift = 0.0
	var change = 0.0
	for w in v.children:
		w.x += shift
		w.offset_modifier += shift
		change += w.change
		shift += w.shift + change


func get_ancestor(
	vil: ArrangedVisualizerNode, v: ArrangedVisualizerNode, default_ancestor: ArrangedVisualizerNode
) -> ArrangedVisualizerNode:
	if vil.ancestor in v.parent.children:
		return vil.ancestor
	else:
		return default_ancestor


func second_walk(v: ArrangedVisualizerNode, m: float = 0.0):
	for w in v.children:
		second_walk(w, m + v.offset_modifier)
	v.x += m
