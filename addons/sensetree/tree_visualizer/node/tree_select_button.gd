@tool
class_name TreeVisualizerSelectButton
extends Button

signal tree_selected(tree: SenseTree)

const DEFAULT_BUTTON_ICON = preload("res://addons/sensetree/behavior_tree/icon/Tree.svg")

var _tree: SenseTree


func _init(tree: SenseTree) -> void:
	_tree = tree
	text = tree.name
	icon = DEFAULT_BUTTON_ICON


func _pressed() -> void:
	tree_selected.emit(_tree)
