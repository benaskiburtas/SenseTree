@tool
@icon("res://addons/sensetree/behavior_tree/icon/Blackboard.svg")
class_name SenseTreeBlackboard
extends Node

var data: Dictionary = {}


func set_value(key: String, value: Variant) -> void:
	data[key] = value


func get_value(key: String) -> Variant:
	if not has_key(key):
		push_error("Error: Key '%s' not found in blackboard." % key)
		return null

	return data.get(key)


func get_keys() -> PackedStringArray:
	return data.keys() as PackedStringArray


func has_key(key: String) -> bool:
	return data.has(key)


func clear_value(key: String) -> void:
	if has_key(key):
		data.erase(key)
