@tool
class_name TreeVisualizerGraphNode
extends GraphNode

enum AlignmentType {VERTICAL, HORIZONTAL}

const MINIMUM_WIDTH: int = 50
const MINIMUM_HEIGHT: int = 50
const HORIZONTAL_SPACING_OFFSET: float = 300
const VERTICAL_SPACING_OFFSET: float = 100

var _alignment_mode: AlignmentType 


func _init(
	arranged_node: ArrangedVisualizerNode,
	style_boxes: TreeVisualizerGraphNodeStyleBoxes,
	alignment_mode: AlignmentType = AlignmentType.VERTICAL
) -> void:
	_alignment_mode = alignment_mode
	_set_minimum_size()
	_set_node_position(arranged_node)

	var sense_node = arranged_node.tree
	_inherit_node_properties(sense_node)
	_assign_styleboxes_by_group(sense_node, style_boxes)


func _set_minimum_size() -> void:
	custom_minimum_size = Vector2(MINIMUM_WIDTH, MINIMUM_HEIGHT)


func _set_node_position(arranged_node: ArrangedVisualizerNode) -> void:
	var node_x_offset_units: int 
	var node_y_offset_units: int
	
	if (_alignment_mode == AlignmentType.HORIZONTAL):
		node_x_offset_units = arranged_node.x
		node_y_offset_units = arranged_node.y
	elif(_alignment_mode == AlignmentType.VERTICAL):
		node_x_offset_units = arranged_node.y
		node_y_offset_units = arranged_node.x
	else:
		push_error("Unsupported tree graph alignment type: %s" % _alignment_mode)

	var x_position = (node_x_offset_units + 1) * HORIZONTAL_SPACING_OFFSET
	var y_position = (node_y_offset_units) * VERTICAL_SPACING_OFFSET
	position_offset = Vector2(x_position, y_position)

func _inherit_node_properties(node: SenseTreeNode) -> void:
	self.title = node.name


func _assign_styleboxes_by_group(
	node: SenseTreeNode, style_boxes: TreeVisualizerGraphNodeStyleBoxes
) -> void:
	var group = node.get_node_group()

	var panel_stylebox = style_boxes.get_stylebox(group, style_boxes.StyleBoxType.PANEL_STYLE_BOX)
	var panel_selected_stylebox = style_boxes.get_stylebox(
		group, style_boxes.StyleBoxType.PANEL_SELECTED_STYLE_BOX
	)
	var titlebar_stylebox = style_boxes.get_stylebox(
		group, style_boxes.StyleBoxType.TITLEBAR_STYLE_BOX
	)
	var titlebar_selected_stylebox = style_boxes.get_stylebox(
		group, style_boxes.StyleBoxType.TITLEBAR_SELECTED_STYLE_BOX
	)
	var slot_stylebox = style_boxes.get_stylebox(group, style_boxes.StyleBoxType.SLOT_STYLE_BOX)

	add_theme_stylebox_override("panel", panel_stylebox)
	add_theme_stylebox_override("panel_selected", panel_selected_stylebox)
	add_theme_stylebox_override("titlebar", titlebar_stylebox)
	add_theme_stylebox_override("titlebar_selected", titlebar_selected_stylebox)
	add_theme_stylebox_override("slot", slot_stylebox)
