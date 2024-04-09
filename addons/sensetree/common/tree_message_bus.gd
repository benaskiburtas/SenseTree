extends Node

signal tree_property_changed(node: Node, property_name: String)
signal tree_node_added(node: Node, child_node: Node)
signal tree_node_removed(node: Node, child_node: Node)
