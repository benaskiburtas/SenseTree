@tool
class_name TreeVisualizerAddNodeButton
extends TreeVisualizerActionButton

signal create_node_requested(node_class: String)

const BUTTON_TEXT = "Add Node"

const COMPOSITE_SUBMENU_NAME = "Composite"
const DECORATOR_SUBMENU_NAME = "Decorator"
const LEAF_SUBMENU_NAME = "Leaf"

var _composite_submenu_items: Array = []
var _decorator_submenu_items: Array = []
var _leaf_submenu_items: Array = []


func _init() -> void:
	super()
	text = BUTTON_TEXT


func _assign_button_state() -> void:
	if self.selected_node == null or _selected_node_group == null:
		disabled = true
		
	var scene_node = self.selected_node.scene_node
	match _selected_node_group:
		SenseTreeConstants.NodeGroup.TREE:
			disabled = scene_node.get_child_count() != 0
		SenseTreeConstants.NodeGroup.COMPOSITE:
			disabled = false
		SenseTreeConstants.NodeGroup.DECORATOR:
			disabled = scene_node.get_child_count() != 0
		SenseTreeConstants.NodeGroup.LEAF:
			disabled = true
		_:
			disabled = true


func _assign_button_options() -> void:
	get_popup().clear(true)
	_clear_submenu_links()
	if self.selected_node == null or _selected_node_group == null:
		return

	match _selected_node_group:
		SenseTreeConstants.NodeGroup.TREE:
			_add_composite_submenu()
			_add_decorator_submenu()
			_add_leaf_submenu()
		SenseTreeConstants.NodeGroup.COMPOSITE:
			_add_composite_submenu()
			_add_decorator_submenu()
			_add_leaf_submenu()
		SenseTreeConstants.NodeGroup.DECORATOR:
			_add_decorator_submenu()
			_add_leaf_submenu()
		SenseTreeConstants.NodeGroup.LEAF:
			return


func _clear_submenu_links() -> void:
	_composite_submenu_items.clear()
	_decorator_submenu_items.clear()
	_leaf_submenu_items.clear()


func _add_composite_submenu() -> void:
	_add_submenu(
		COMPOSITE_SUBMENU_NAME,
		SenseTreeConstants.NodeGroup.COMPOSITE,
		_composite_submenu_items,
		_on_add_composite_node_pressed
	)


func _add_decorator_submenu() -> void:
	_add_submenu(
		DECORATOR_SUBMENU_NAME,
		SenseTreeConstants.NodeGroup.DECORATOR,
		_decorator_submenu_items,
		_on_add_decorator_node_pressed
	)


func _add_leaf_submenu() -> void:
	_add_submenu(
		LEAF_SUBMENU_NAME,
		SenseTreeConstants.NodeGroup.LEAF,
		_leaf_submenu_items,
		_on_add_leaf_node_pressed
	)


func _add_submenu(
	submenu_name: String,
	node_group: SenseTreeConstants.NodeGroup,
	submenu_links: Array,
	submenu_item_click_handler: Callable
) -> void:
	var popup_container = get_popup()

	var group_submenu = PopupMenu.new()
	group_submenu.name = submenu_name

	var group_class_definitions = SenseTreeHelpers.get_class_definitions_by_group(node_group)
	for i in range(group_class_definitions.size()):
		var node_class_name: String = group_class_definitions[i]["class"]

		var node_icon_path = SenseTreeHelpers.try_acquire_icon_path(node_class_name)
		if node_icon_path:
			var node_icon: Texture2D = load(node_icon_path)
			if node_icon:
				group_submenu.add_icon_item(node_icon, node_class_name)
		else:
			group_submenu.add_item(node_class_name)

		submenu_links.push_back(node_class_name)

	group_submenu.connect("index_pressed", submenu_item_click_handler)

	popup_container.add_child(group_submenu)
	popup_container.add_submenu_item(submenu_name, submenu_name)


func _on_add_composite_node_pressed(menu_item_index: int):
	if menu_item_index < _composite_submenu_items.size():
		create_node_requested.emit(_composite_submenu_items[menu_item_index])


func _on_add_decorator_node_pressed(menu_item_index: int):
	if menu_item_index < _decorator_submenu_items.size():
		create_node_requested.emit(_decorator_submenu_items[menu_item_index])


func _on_add_leaf_node_pressed(menu_item_index: int):
	if menu_item_index < _leaf_submenu_items.size():
		create_node_requested.emit(_leaf_submenu_items[menu_item_index])
