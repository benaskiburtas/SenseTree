@tool
class_name TreeVisualizerGraphNode
extends GraphNode

enum PortType { INPUT, OUTPUT }
enum AlignmentType { VERTICAL, HORIZONTAL }

const INPUT_PORT_TYPE = PortType.INPUT
const OUTPUT_PORT_TYPE = PortType.OUTPUT
const DEFAULT_SLOT_INDEX: int = 0

const MINIMUM_WIDTH: int = 50
const MINIMUM_HEIGHT: int = 50
const CONTENT_AREA_MARGIN: int = 5
const PROPERTY_ITEM_MARGIN: int = 5

const HORIZONTAL_SPACING_OFFSET: float = 350
const VERTICAL_SPACING_OFFSET: float = 100

var _alignment_mode: AlignmentType
var _node_icon_texture: Texture2D

var _content_container: VBoxContainer
var _port: Control
var _titlebar: HBoxContainer
var _titlebar_icon: TextureRect

var _has_properties: bool = false:
	set(has_properties):
		_has_properties = has_properties
		_content_container.get_parent().visible = has_properties


func _init(
	arranged_node: ArrangedVisualizerNode,
	style_boxes: TreeVisualizerGraphNodeStyleBoxes,
	alignment_mode: AlignmentType = AlignmentType.HORIZONTAL
) -> void:
	var sense_node = arranged_node.tree

	_alignment_mode = alignment_mode
	_set_base_properties()
	_initialize_port()
	_initialize_content_vbox()
	_initialize_titlebar()
	_initialize_titlebar_icon()

	_configure_ports(sense_node)
	_load_node_icon(sense_node)
	_load_node_title(sense_node)
	_load_node_properties(sense_node)
	_assign_styleboxes_by_group(sense_node, style_boxes)

	_set_node_position(arranged_node)


func _set_base_properties() -> void:
	custom_minimum_size = Vector2(MINIMUM_WIDTH, MINIMUM_HEIGHT)
	draggable = false


func _initialize_port() -> void:
	_port = Control.new()
	add_child(_port)


func _initialize_content_vbox() -> void:
	var margin_content_container = MarginContainer.new()
	_set_container_margins(margin_content_container, CONTENT_AREA_MARGIN)
	_set_container_to_expand_fully(margin_content_container)

	_content_container = VBoxContainer.new()
	_set_container_to_expand_fully(_content_container)

	margin_content_container.add_child(_content_container)

	add_child(margin_content_container)
	_has_properties = false


func _initialize_titlebar() -> void:
	_titlebar = get_titlebar_hbox()


func _initialize_titlebar_icon() -> void:
	_titlebar_icon = TextureRect.new()
	_titlebar.add_child(_titlebar_icon)
	_titlebar.move_child(_titlebar_icon, 0)


func _configure_ports(sense_node: SenseTreeNode) -> void:
	var node_group: SenseTreeConstants.NodeGroup = sense_node.get_node_group()
	match node_group:
		SenseTreeConstants.NodeGroup.TREE:
			set_slot(
				DEFAULT_SLOT_INDEX,
				false,
				INPUT_PORT_TYPE,
				SenseTreeConstants.TREE_GROUP_BASE_COLOR,
				true,
				OUTPUT_PORT_TYPE,
				SenseTreeConstants.TREE_GROUP_BASE_COLOR
			)
		SenseTreeConstants.NodeGroup.COMPOSITE:
			set_slot(
				DEFAULT_SLOT_INDEX,
				true,
				INPUT_PORT_TYPE,
				SenseTreeConstants.COMPOSITE_GROUP_BASE_COLOR,
				true,
				OUTPUT_PORT_TYPE,
				SenseTreeConstants.COMPOSITE_GROUP_BASE_COLOR
			)
		SenseTreeConstants.NodeGroup.DECORATOR:
			set_slot(
				DEFAULT_SLOT_INDEX,
				true,
				INPUT_PORT_TYPE,
				SenseTreeConstants.DECORATOR_GROUP_BASE_COLOR,
				true,
				OUTPUT_PORT_TYPE,
				SenseTreeConstants.DECORATOR_GROUP_BASE_COLOR
			)
		SenseTreeConstants.NodeGroup.LEAF:
			set_slot(
				DEFAULT_SLOT_INDEX,
				true,
				INPUT_PORT_TYPE,
				SenseTreeConstants.LEAF_GROUP_BASE_COLOR,
				false,
				OUTPUT_PORT_TYPE,
				SenseTreeConstants.LEAF_GROUP_BASE_COLOR
			)
		_:
			push_error()
			return


func _load_node_icon(sense_node: SenseTreeNode) -> void:
	var sense_node_class: String = sense_node.get_sensenode_class()
	if not sense_node_class or sense_node_class.is_empty():
		push_warning("Could not resolve class name from SenseTree node %s." % sense_node.name)
		return

	var icon_path: String = _try_acquire_icon_path(sense_node_class)
	if not icon_path or icon_path.is_empty():
		push_warning(
			"Could not find matching icon for SenseTree node of type %s." % sense_node_class
		)
		return

	_node_icon_texture = load(icon_path)
	_titlebar_icon.texture = _node_icon_texture


func _load_node_title(sense_node: SenseTreeNode) -> void:
	var title_label = Label.new()
	title_label.text = sense_node.name
	_titlebar.add_child(title_label)


func _load_node_properties(sense_node: SenseTreeNode) -> void:
	var properties: Array[SenseTreeExportedProperty] = sense_node.get_exported_properties()

	if not properties.is_empty():
		_has_properties = true

	for property in properties:
		var property_container = HBoxContainer.new()
		_set_container_margins(property_container, PROPERTY_ITEM_MARGIN)
		property_container.add_theme_constant_override("separation", 10)

		var name_label = Label.new()
		name_label.text = "%s:" % property.property_title
		property_container.add_child(name_label)

		var value_label = Label.new()
		value_label.text = str(property.value)
		property_container.add_child(value_label)

		_content_container.add_child(property_container)


func _try_acquire_icon_path(sense_node_class: String) -> String:
	var all_classes: Array[Dictionary] = ProjectSettings.get_global_class_list()
	for class_definition in all_classes:
		if class_definition.has("class") and class_definition.get("class") == sense_node_class:
			if class_definition.has("icon"):
				return class_definition.get("icon")

	return String()


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


func _set_node_position(arranged_node: ArrangedVisualizerNode) -> void:
	var node_x_offset_units: int
	var node_y_offset_units: int

	if _alignment_mode == AlignmentType.VERTICAL:
		node_x_offset_units = arranged_node.x
		node_y_offset_units = arranged_node.y
	elif _alignment_mode == AlignmentType.HORIZONTAL:
		node_x_offset_units = arranged_node.y
		node_y_offset_units = arranged_node.x
	else:
		push_error("Unsupported tree graph alignment type: %s" % _alignment_mode)

	var x_position = (node_x_offset_units + 1) * HORIZONTAL_SPACING_OFFSET
	var y_position = (node_y_offset_units) * VERTICAL_SPACING_OFFSET
	position_offset = Vector2(x_position, y_position)


func _set_container_margins(container: Container, margin: int) -> void:
	container.add_theme_constant_override("margin_top", margin)
	container.add_theme_constant_override("margin_left", margin)
	container.add_theme_constant_override("margin_bottom", margin)
	container.add_theme_constant_override("margin_right", margin)


func _set_container_to_expand_fully(container: Container) -> void:
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_EXPAND_FILL
