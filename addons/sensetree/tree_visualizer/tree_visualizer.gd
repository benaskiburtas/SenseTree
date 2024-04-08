@tool
class_name SenseTreeVisualizer
extends Control

var _graph_edit: GraphEdit

func _ready():
	_graph_edit = GraphEdit.new()
	_graph_edit.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	add_child(_graph_edit)

	var theme = _graph_edit.get_theme()
	if theme and theme.is_valid():
		theme.default_color = Color.GRAY
		_graph_edit.set_theme(theme)
	else:
		print("Error: Could not get theme from GraphEdit") 

	populate_example_graph()

func populate_example_graph():
	var root = GraphNode.new()
	root.set_name("Root")
	root.set_title("Sequence")
	root.set_offset(100, 50)
	_graph_edit.add_child(root)

	var action1 = GraphNode.new()
	action1.set_name("Action1")
	action1.set_title("Action")
	action1.set_offset(300, 100)
	_graph_edit.add_child(action1)

	var condition = GraphNode.new()
	condition.set_name("Condition")
	condition.set_title("Condition")
	condition.set_offset(300, 200)
	_graph_edit.add_child(condition)

	var action2 = GraphNode.new()
	action2.set_name("Action2")
	action2.set_title("Action")
	action2.set_offset(500, 150)
	_graph_edit.add_child(action2)

	_graph_edit.connect_node("Root", 0, "Action1", 0)
	_graph_edit.connect_node("Action1", 0, "Condition", 0)
	_graph_edit.connect_node("Condition", 0, "Action2", 0)
	_graph_edit.connect_node("Condition", 1, "Root", 0)
