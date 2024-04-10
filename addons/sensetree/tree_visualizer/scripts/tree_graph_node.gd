@tool
class_name TreeVisualizerGraphNode
extends GraphNode

const MINIMUM_WIDTH: int = 75
const MINIMUM_HEIGHT: int = 75


func _init(node: SenseTreeNode, style_boxes: TreeVisualizerGraphNodeStyleBoxes) -> void:
	_set_minimum_size()
	_inherit_node_properties(node)
	_assign_styleboxes_by_group(node, style_boxes)


func _set_minimum_size() -> void:
	custom_minimum_size = Vector2(MINIMUM_WIDTH, MINIMUM_HEIGHT)


func _inherit_node_properties(node: SenseTreeNode) -> void:
	self.title = node.name
	
func _assign_styleboxes_by_group(node: SenseTreeNode, style_boxes: TreeVisualizerGraphNodeStyleBoxes) -> void:
	var group = node.get_node_group()
	
	var panel_stylebox = style_boxes.get_stylebox(group, style_boxes.StyleBoxType.PANEL_STYLE_BOX)
	var panel_selected_stylebox = style_boxes.get_stylebox(group, style_boxes.StyleBoxType.PANEL_SELECTED_STYLE_BOX)
	var titlebar_stylebox = style_boxes.get_stylebox(group, style_boxes.StyleBoxType.TITLEBAR_STYLE_BOX)
	var titlebar_selected_stylebox = style_boxes.get_stylebox(group, style_boxes.StyleBoxType.TITLEBAR_SELECTED_STYLE_BOX)
	var slot_stylebox = style_boxes.get_stylebox(group, style_boxes.StyleBoxType.SLOT_STYLE_BOX)
	
	add_theme_stylebox_override("panel", panel_stylebox)
	add_theme_stylebox_override("panel_selected", panel_selected_stylebox)
	add_theme_stylebox_override("titlebar", titlebar_stylebox)
	add_theme_stylebox_override("titlebar_selected", titlebar_selected_stylebox)
	add_theme_stylebox_override("slot", slot_stylebox)
	
	
