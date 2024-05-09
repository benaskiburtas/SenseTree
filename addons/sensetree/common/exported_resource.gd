@tool
class_name SenseTreeExportedProperty
extends Resource

var property_name: String
var property_title: String
var value: Variant


func _init(_property_name: String, _property_title: String, _value: Variant) -> void:
	self.property_name = _property_name
	self.property_title = _property_title
	self.value = _value
