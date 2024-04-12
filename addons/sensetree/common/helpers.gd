extends Node

const SENSE_TREE_CLASS_PATTERN_STRING: String = "SenseTree"

var _sense_tree_class_regex: RegEx = RegEx.create_from_string(SENSE_TREE_CLASS_PATTERN_STRING)
var _sense_tree_classes: Dictionary = _form_sense_tree_class_dictionary()


func try_acquire_icon_path(sense_tree_class: String) -> String:
	if sense_tree_class in _sense_tree_classes:
		var class_definition = _sense_tree_classes[sense_tree_class]
		if "icon" in class_definition:
			return class_definition["icon"]
	return String()


func _form_sense_tree_class_dictionary() -> Dictionary:
	var global_class_list: Array[Dictionary] = ProjectSettings.get_global_class_list()
	var sense_tree_classes = global_class_list.filter(_has_class_name).filter(_is_sense_tree_class)

	var sense_tree_dict: Dictionary = {}

	for class_definition in sense_tree_classes:
		sense_tree_dict[class_definition["class"]] = class_definition

	return sense_tree_dict


func _is_sense_tree_class(class_entry: Dictionary) -> bool:
	if _sense_tree_class_regex.search(class_entry.get("class")) == null:
		return false
	return true


func _has_class_name(class_entry: Dictionary) -> bool:
	if class_entry == null or not "class" in class_entry:
		return false
	return true
