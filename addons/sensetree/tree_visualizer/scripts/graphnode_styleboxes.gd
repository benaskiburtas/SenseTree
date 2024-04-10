class_name TreeVisualizerGraphNodeStyleBoxes
extends Resource

enum StyleBoxType {
	PANEL_STYLE_BOX,
	PANEL_SELECTED_STYLE_BOX,
	TITLEBAR_STYLE_BOX,
	TITLEBAR_SELECTED_STYLE_BOX,
	SLOT_STYLE_BOX
}

const FALL_BACK_COLOR = Color("#000000")
const TREE_GROUP_BASE_COLOR = Color("#1c3b18")
const COMPOSITE_GROUP_BASE_COLOR = Color("#28801c")
const DECORATOR_GROUP_BASE_COLOR = Color("#91298a")
const LEAF_GROUP_BASE_COLOR = Color("#29c714")

var group_styleboxes = {
	SenseTreeConstants.NodeGroup.TREE: {},
	SenseTreeConstants.NodeGroup.COMPOSITE: {},
	SenseTreeConstants.NodeGroup.DECORATOR: {},
	SenseTreeConstants.NodeGroup.LEAF: {}
}


func _init():
	_build_styleboxes()


func get_stylebox(group: SenseTreeConstants.NodeGroup, box_type: StyleBoxType) -> StyleBox:
	if group_styleboxes.has(group) and group_styleboxes[group].has(box_type):
		return group_styleboxes[group][box_type]
	else:
		return null


func _build_styleboxes() -> void:
	for group in SenseTreeConstants.NodeGroup.values():
		group_styleboxes[group] = {
			StyleBoxType.PANEL_STYLE_BOX: _build_panel_stylebox(get_group_color(group), 0.5),
			StyleBoxType.PANEL_SELECTED_STYLE_BOX:
			_build_panel_stylebox(get_group_color(group), 0.85),
			StyleBoxType.TITLEBAR_STYLE_BOX:
			_build_titlebar_stylebox(get_group_color(group), 0.3, 0.65),
			StyleBoxType.TITLEBAR_SELECTED_STYLE_BOX:
			_build_titlebar_stylebox(get_group_color(group), 0.15, 1.0),
			StyleBoxType.SLOT_STYLE_BOX: _build_slot_stylebox(get_group_color(group), 0.15, 0.4)
		}


func get_group_color(group: SenseTreeConstants.NodeGroup) -> Color:
	match group:
		SenseTreeConstants.NodeGroup.TREE:
			return TREE_GROUP_BASE_COLOR
		SenseTreeConstants.NodeGroup.COMPOSITE:
			return COMPOSITE_GROUP_BASE_COLOR
		SenseTreeConstants.NodeGroup.DECORATOR:
			return DECORATOR_GROUP_BASE_COLOR
		SenseTreeConstants.NodeGroup.LEAF:
			return LEAF_GROUP_BASE_COLOR
		_:
			push_warning("Could not resolve graph node color for group %s" % group)
			return FALL_BACK_COLOR


func _build_panel_stylebox(group_color: Color, alpha: float) -> StyleBoxFlat:
	var adjusted_color = Color(group_color, alpha)
	var stylebox = StyleBoxFlat.new()
	stylebox.set_bg_color(adjusted_color)
	return stylebox


func _build_titlebar_stylebox(
	group_color: Color, darken_factor: float, alpha: float
) -> StyleBoxFlat:
	var adjusted_opacity = Color(group_color, alpha)
	var adjusted_color = adjusted_opacity * (1.0 - darken_factor)
	var stylebox = StyleBoxFlat.new()
	stylebox.set_bg_color(adjusted_color)
	return stylebox


func _build_slot_stylebox(group_color: Color, lighten_factor: float, alpha: float) -> StyleBoxFlat:
	var adjusted_opacity = Color(group_color, alpha)
	var adjusted_color = adjusted_opacity * (1.0 + lighten_factor)
	var stylebox = StyleBoxFlat.new()
	stylebox.set_bg_color(adjusted_color)
	return stylebox
