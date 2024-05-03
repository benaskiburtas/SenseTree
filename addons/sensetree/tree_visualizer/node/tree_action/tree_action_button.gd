@tool
class_name TreeVisualizerTreeActionButton
extends Button

var selected_tree: SenseTree = null:
	set(new_tree):
		if new_tree != null:
			selected_tree = new_tree
		else:
			selected_tree = null
		_assign_button_state()


func _init():
	#add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	disabled = true


func _assign_button_state() -> void:
	pass
