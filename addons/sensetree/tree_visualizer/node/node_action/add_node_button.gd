@tool
class_name TreeVisualizerAddNodeButton
extends TreeVisualizerNodeActionButton

signal create_node_requested(node_class: String)

enum IncludeTypes { ALL, NATIVE, EXAMPLE, CUSTOM }

const BUTTON_TEXT = "Add Node"

const COMPOSITE_SUBMENU_NAME = "Composite"
const DECORATOR_SUBMENU_NAME = "Decorator"
const LEAF_SUBMENU_NAME = "Leaf"

const NATIVE_LEAF_SUBMENU_NAME = "Native"
const EXAMPLE_LEAF_SUBMENU_NAME = "Example"
const CUSTOM_LEAF_SUBMENU_NAME = "Custom"

# Node Categories
var _composite_submenu_items: Array = []
var _decorator_submenu_items: Array = []
var _leaf_submenu_items: Array = []

# Leaf Sub-categories
var _native_leaf_submenu_items: Array = []
var _example_leaf_submenu_items: Array = []
var _custom_leaf_submenu_items: Array = []


func _init() -> void:
	super()
	text = BUTTON_TEXT


func _assign_button_state() -> void:
	if self.selected_node == null or _selected_node_group == null:
		disabled = true
		return

	var node = self.selected_node.sensetree_node
	match _selected_node_group:
		SenseTreeConstants.NodeGroup.TREE:
			disabled = node.get_child_count() != 0
		SenseTreeConstants.NodeGroup.COMPOSITE:
			disabled = false
		SenseTreeConstants.NodeGroup.DECORATOR:
			disabled = node.get_child_count() != 0
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

	_native_leaf_submenu_items.clear()
	_example_leaf_submenu_items.clear()
	_custom_leaf_submenu_items.clear()


func _add_composite_submenu() -> void:
	var popup_menu = get_popup()

	var composite_submenu = _form_submenu(
		SenseTreeHelpers.get_class_definitions_by_group(SenseTreeConstants.NodeGroup.COMPOSITE),
		COMPOSITE_SUBMENU_NAME,
		_composite_submenu_items,
		_on_add_composite_node_pressed,
	)

	popup_menu.add_child(composite_submenu)
	popup_menu.add_submenu_item(COMPOSITE_SUBMENU_NAME, COMPOSITE_SUBMENU_NAME)


func _add_decorator_submenu() -> void:
	var popup_menu = get_popup()

	var decorator_submenu = _form_submenu(
		SenseTreeHelpers.get_class_definitions_by_group(SenseTreeConstants.NodeGroup.DECORATOR),
		DECORATOR_SUBMENU_NAME,
		_decorator_submenu_items,
		_on_add_decorator_node_pressed,
	)

	popup_menu.add_child(decorator_submenu)
	popup_menu.add_submenu_item(DECORATOR_SUBMENU_NAME, DECORATOR_SUBMENU_NAME)


func _add_leaf_submenu() -> void:
	var popup_menu = get_popup()
	var current_submenu_index = 0

	var leaf_submenu = PopupMenu.new()
	leaf_submenu.name = LEAF_SUBMENU_NAME

	# Add Native Leaf Nodes
	var native_leaf_node_definitions = SenseTreeHelpers.get_leaf_definitions_by_source_type(
		SenseTreeConstants.NodeSourceType.NATIVE
	)
	var native_leaf_submenu = _form_submenu(
		SenseTreeHelpers.get_leaf_definitions_by_source_type(
			SenseTreeConstants.NodeSourceType.NATIVE
		),
		NATIVE_LEAF_SUBMENU_NAME,
		_native_leaf_submenu_items,
		_on_add_native_leaf_node_pressed
	)

	if native_leaf_submenu.item_count != 0:
		leaf_submenu.add_child(native_leaf_submenu)
		leaf_submenu.add_submenu_item(NATIVE_LEAF_SUBMENU_NAME, NATIVE_LEAF_SUBMENU_NAME)
	else:
		leaf_submenu.add_item(NATIVE_LEAF_SUBMENU_NAME)
		leaf_submenu.set_item_disabled(current_submenu_index, true)
	current_submenu_index = current_submenu_index + 1

	# Add Example Leaf Nodes
	var example_leaf_node_definitions = SenseTreeHelpers.get_leaf_definitions_by_source_type(
		SenseTreeConstants.NodeSourceType.EXAMPLE
	)
	var example_leaf_submenu = _form_submenu(
		SenseTreeHelpers.get_leaf_definitions_by_source_type(
			SenseTreeConstants.NodeSourceType.EXAMPLE
		),
		EXAMPLE_LEAF_SUBMENU_NAME,
		_example_leaf_submenu_items,
		_on_add_example_leaf_node_pressed
	)

	if example_leaf_submenu.item_count != 0:
		leaf_submenu.add_child(example_leaf_submenu)
		leaf_submenu.add_submenu_item(EXAMPLE_LEAF_SUBMENU_NAME, EXAMPLE_LEAF_SUBMENU_NAME)
	else:
		leaf_submenu.add_item(EXAMPLE_LEAF_SUBMENU_NAME)
		leaf_submenu.set_item_disabled(current_submenu_index, true)
	current_submenu_index = current_submenu_index + 1

	# Add Custom Leaf Nodes
	var custom_leaf_node_definitions = SenseTreeHelpers.get_leaf_definitions_by_source_type(
		SenseTreeConstants.NodeSourceType.CUSTOM
	)
	var custom_leaf_submenu = _form_submenu(
		SenseTreeHelpers.get_leaf_definitions_by_source_type(
			SenseTreeConstants.NodeSourceType.CUSTOM
		),
		CUSTOM_LEAF_SUBMENU_NAME,
		_custom_leaf_submenu_items,
		_on_add_custom_leaf_node_pressed
	)
	if custom_leaf_submenu.item_count != 0:
		leaf_submenu.add_child(custom_leaf_submenu)
		leaf_submenu.add_submenu_item(CUSTOM_LEAF_SUBMENU_NAME, CUSTOM_LEAF_SUBMENU_NAME)
	else:
		leaf_submenu.add_item(CUSTOM_LEAF_SUBMENU_NAME)
		leaf_submenu.set_item_disabled(current_submenu_index, true)
	current_submenu_index = current_submenu_index + 1

	# Include Leaf Node submenu into main add node menu
	popup_menu.add_child(leaf_submenu)
	popup_menu.add_submenu_item(LEAF_SUBMENU_NAME, LEAF_SUBMENU_NAME)


func _form_submenu(
	class_definitions: Array[Dictionary],
	submenu_name: String,
	submenu_links: Array,
	submenu_item_click_handler: Callable,
) -> PopupMenu:
	var submenu = PopupMenu.new()
	submenu.allow_search = true
	submenu.name = submenu_name

	for i in range(class_definitions.size()):
		var full_node_class_name: String = class_definitions[i]["class"]
		var node_class_name: String = full_node_class_name.replace(
			SenseTreeConstants.PLUGIN_NODE_CLASS_PREFIX, ""
		)

		var node_icon_path = SenseTreeHelpers.try_acquire_icon_path(full_node_class_name)
		if node_icon_path:
			var node_icon: Texture2D = load(node_icon_path)
			if node_icon:
				submenu.add_icon_item(node_icon, node_class_name)
		else:
			submenu.add_item(node_class_name)
		submenu_links.push_back(full_node_class_name)

	submenu.connect("index_pressed", submenu_item_click_handler)

	return submenu


func _on_add_composite_node_pressed(menu_item_index: int) -> void:
	if menu_item_index < _composite_submenu_items.size():
		create_node_requested.emit(_composite_submenu_items[menu_item_index])
		disabled = true


func _on_add_decorator_node_pressed(menu_item_index: int) -> void:
	if menu_item_index < _decorator_submenu_items.size():
		create_node_requested.emit(_decorator_submenu_items[menu_item_index])
		disabled = true


func _on_add_native_leaf_node_pressed(menu_item_index: int) -> void:
	if menu_item_index < _native_leaf_submenu_items.size():
		create_node_requested.emit(_native_leaf_submenu_items[menu_item_index])
		disabled = true


func _on_add_example_leaf_node_pressed(menu_item_index: int) -> void:
	if menu_item_index < _example_leaf_submenu_items.size():
		create_node_requested.emit(_example_leaf_submenu_items[menu_item_index])
		disabled = true


func _on_add_custom_leaf_node_pressed(menu_item_index: int) -> void:
	if menu_item_index < _custom_leaf_submenu_items.size():
		create_node_requested.emit(_custom_leaf_submenu_items[menu_item_index])
		disabled = true
