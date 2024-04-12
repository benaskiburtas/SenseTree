@tool
class_name TreeVisualizerAddNodeButton
extends TreeVisualizerActionButton

const BUTTON_TEXT = "Add Node"

const COMPOSITES_SUBMENU_NAME = "Composites"
const DECORATORS_SUBMENU_NAME = "Decorators"
const LEAVES_SUBMENU_NAME = "Leaves"


func _init() -> void:
	super()
	text = BUTTON_TEXT


func _assign_button_state() -> void:
	if self.selected_node == null or _selected_node_group == null:
		disabled = true

	match _selected_node_group:
		SenseTreeConstants.NodeGroup.TREE:
			disabled = self.selected_node.get_child_count() == 0
		SenseTreeConstants.NodeGroup.COMPOSITE:
			disabled = false
		SenseTreeConstants.NodeGroup.DECORATOR:
			disabled = self.selected_node.get_child_count() == 0
		SenseTreeConstants.NodeGroup.LEAF:
			disabled = true
		_:
			disabled = true


func _assign_button_options() -> void:
	get_popup().clear(true)
	if self.selected_node == null or _selected_node_group == null:
		return
	
	match _selected_node_group:
		SenseTreeConstants.NodeGroup.TREE:
			_add_submenu(COMPOSITES_SUBMENU_NAME, SenseTreeConstants.NodeGroup.COMPOSITE)
			_add_submenu(DECORATORS_SUBMENU_NAME, SenseTreeConstants.NodeGroup.DECORATOR)
			_add_submenu(LEAVES_SUBMENU_NAME, SenseTreeConstants.NodeGroup.LEAF)
		SenseTreeConstants.NodeGroup.COMPOSITE:
			_add_submenu(COMPOSITES_SUBMENU_NAME, SenseTreeConstants.NodeGroup.COMPOSITE)
			_add_submenu(DECORATORS_SUBMENU_NAME, SenseTreeConstants.NodeGroup.DECORATOR)
			_add_submenu(LEAVES_SUBMENU_NAME, SenseTreeConstants.NodeGroup.LEAF)
		SenseTreeConstants.NodeGroup.DECORATOR:
			_add_submenu(DECORATORS_SUBMENU_NAME, SenseTreeConstants.NodeGroup.DECORATOR)
			_add_submenu(LEAVES_SUBMENU_NAME, SenseTreeConstants.NodeGroup.LEAF)
		SenseTreeConstants.NodeGroup.LEAF:
			return


func _add_submenu(submenu_name: String, node_group: SenseTreeConstants.NodeGroup) -> void:
	var popup_container = get_popup()
	
	var group_submenu = PopupMenu.new()
	group_submenu.name = submenu_name

	for node in SenseTreeHelpers.get_class_definitions_by_group(node_group):
		var node_class_name: String = node["class"]

		var node_icon_path = SenseTreeHelpers.try_acquire_icon_path(node_class_name)
		if node_icon_path:
			var node_icon: Texture2D = load(node_icon_path)
			if node_icon:
				group_submenu.add_icon_item(node_icon, node_class_name)
		else:
			group_submenu.add_item(node_class_name)
	
	popup_container.add_child(group_submenu)
	popup_container.add_submenu_item(submenu_name, submenu_name)
