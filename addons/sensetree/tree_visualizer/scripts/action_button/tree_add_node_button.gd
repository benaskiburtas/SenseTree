@tool
class_name TreeVisualizerAddNodeButton
extends TreeVisualizerActionButton

const BUTTON_TEXT = "Add Node"


func _init() -> void:
	super()
	text = BUTTON_TEXT

func _ready():
	pass

func _enter_tree():
	_get_sensetree_decorator_list()

func _assign_button_state() -> void:
	if _selected_node == null or _selected_node_group == null:
		disabled = true
	
	match _selected_node_group:
		SenseTreeConstants.NodeGroup.TREE:
			disabled = _selected_node.get_child_count() == 0
		SenseTreeConstants.NodeGroup.COMPOSITE:
			disabled = false
		SenseTreeConstants.NodeGroup.DECORATOR:
			disabled = _selected_node.get_child_count() == 0
		SenseTreeConstants.NodeGroup.LEAF:
			disabled = true
		_:
			disabled = true

func _assign_button_options() -> void:
	pass
	
func _get_sensetree_decorator_list() -> PackedStringArray:
	return []
