class_name TreeVisualizerGraphNodeStyleBoxes
extends Resource

enum StyleBoxType {
	PANEL_STYLE_BOX,
	PANEL_SELECTED_STYLE_BOX,
	TITLEBAR_STYLE_BOX,
	TITLEBAR_SELECTED_STYLE_BOX,
	SLOT_STYLE_BOX
}

## Level of transparancey 0.0 -> 1.0
const PANEL_STYLE_BOX_ALPHA: float = 0.5
const PANEL_SELECTED_STYLE_BOX_ALPHA: float = 0.9
const TITLEBAR_STYLE_BOX_ALPHA: float = 0.6
const TITLEBAR_SELECTED_STYLE_BOX_ALPHA: float = 1.0
const SLOT_STYLE_BOX_ALPHA: float = 0.5

## Brightness adjustment factors
const TITLEBAR_DARKEN_FACTOR: float = 0.3
const TITLEBAR_SELECTED_DARKEN_FACTOR: float = 0.15
const SLOT_LIGHTEN_FACTOR: float = 0.3

const CONTENT_MARGIN: float = 5
const CORNER_RADIUS: float = 5

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
		var group_color: Color = get_group_color(group)
		group_styleboxes[group] = {
			StyleBoxType.PANEL_STYLE_BOX: _build_panel_stylebox(group_color, PANEL_STYLE_BOX_ALPHA),
			StyleBoxType.PANEL_SELECTED_STYLE_BOX:
			_build_panel_stylebox(group_color, PANEL_SELECTED_STYLE_BOX_ALPHA),
			StyleBoxType.TITLEBAR_STYLE_BOX:
			_build_titlebar_stylebox(group_color, TITLEBAR_DARKEN_FACTOR, TITLEBAR_STYLE_BOX_ALPHA),
			StyleBoxType.TITLEBAR_SELECTED_STYLE_BOX:
			_build_titlebar_stylebox(
				group_color, TITLEBAR_SELECTED_DARKEN_FACTOR, TITLEBAR_SELECTED_STYLE_BOX_ALPHA
			),
			StyleBoxType.SLOT_STYLE_BOX:
			_build_slot_stylebox(group_color, SLOT_LIGHTEN_FACTOR, SLOT_STYLE_BOX_ALPHA)
		}


func get_group_color(group: SenseTreeConstants.NodeGroup) -> Color:
	match group:
		SenseTreeConstants.NodeGroup.TREE:
			return SenseTreeConstants.TREE_GROUP_BASE_COLOR
		SenseTreeConstants.NodeGroup.COMPOSITE:
			return SenseTreeConstants.COMPOSITE_GROUP_BASE_COLOR
		SenseTreeConstants.NodeGroup.DECORATOR:
			return SenseTreeConstants.DECORATOR_GROUP_BASE_COLOR
		SenseTreeConstants.NodeGroup.LEAF:
			return SenseTreeConstants.LEAF_GROUP_BASE_COLOR
		_:
			push_warning("Could not resolve node color for group %s" % group)
			return SenseTreeConstants.FALL_BACK_COLOR


func _build_panel_stylebox(group_color: Color, alpha: float) -> StyleBoxFlat:
	var adjusted_color = Color(group_color, alpha)
	var stylebox = StyleBoxFlat.new()
	stylebox.set_bg_color(adjusted_color)
	stylebox.set_content_margin_all(CONTENT_MARGIN)
	stylebox.corner_radius_bottom_left = CORNER_RADIUS
	stylebox.corner_radius_bottom_right = CORNER_RADIUS
	return stylebox


func _build_titlebar_stylebox(
	group_color: Color, darken_factor: float, alpha: float
) -> StyleBoxFlat:
	var adjusted_opacity: Color = Color(group_color, alpha)
	var adjusted_color: Color = adjusted_opacity * (1.0 - darken_factor)
	var stylebox = StyleBoxFlat.new()
	stylebox.set_bg_color(adjusted_color)
	stylebox.set_content_margin_all(CONTENT_MARGIN)
	stylebox.corner_radius_top_left = CORNER_RADIUS
	stylebox.corner_radius_top_right = CORNER_RADIUS
	return stylebox


func _build_slot_stylebox(group_color: Color, lighten_factor: float, alpha: float) -> StyleBoxFlat:
	var adjusted_opacity = Color(group_color, alpha)
	var adjusted_color = adjusted_opacity * (1.0 + lighten_factor)
	var stylebox = StyleBoxFlat.new()
	stylebox.set_bg_color(adjusted_color)
	return stylebox
