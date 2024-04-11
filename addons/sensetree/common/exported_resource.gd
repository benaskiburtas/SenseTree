@tool
class_name SenseTreeExportedProperty
extends Resource

var property_name: String
var property_title: String
var value: Variant

func _init(_property_name, _property_title, _value):
	property_name = _property_name
	property_title = _property_title
	value = _value
