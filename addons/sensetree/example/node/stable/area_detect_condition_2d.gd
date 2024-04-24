@tool
@icon("res://addons/sensetree/behavior_tree/icon/Condition.svg")
class_name SenseTreeAreaDetectCondition2D
extends SenseTreeConditionLeaf

enum DetectionShape { CIRCLE, RECTANGLE }

## Shape of the detection area
@export var detection_area_shape: DetectionShape
## Detection range - radius for circle shapes, height & size for rectangle shapes
@export var detection_range: int = 50
## Groups that should trigger the detection area
@export var groups_to_detect: Array[String] = []

var _detection_area: Area2D


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	if detection_area_shape == null:
		configuration_warnings.push_back("Detection area shape should be set.")
	if groups_to_detect.is_empty():
		configuration_warnings.push_back("Groups to be detected should be set.")
	return configuration_warnings

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not _detection_area:
		_setup_detection_area(actor)

	var colliding_bodies = _detection_area.get_overlapping_bodies()
	for body in colliding_bodies:
		for group in groups_to_detect:
			if body.is_in_group(group):
				return Status.SUCCESS

	return Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeAreaDetectCondition2D"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var detection_area_shape_property = SenseTreeExportedProperty.new(
		"detection_area_shape", "Detection shape", DetectionShape.keys()[detection_area_shape]
	)
	var detection_range_property = SenseTreeExportedProperty.new(
		"detection_range", "Detection Range", detection_range
	)
	var groups_to_detect_property = SenseTreeExportedProperty.new(
		"groups_to_detect", "Groups to detect", ", ".join(groups_to_detect)
	)
	return [detection_area_shape_property, detection_range_property, groups_to_detect_property]


func _setup_detection_area(actor: Node) -> void:
	_detection_area = Area2D.new()
	if detection_area_shape == null:
		push_warning("No detection area shape set for %s." % get_name())

	var collision_shape = CollisionShape2D.new()
	match detection_area_shape:
		DetectionShape.CIRCLE:
			collision_shape.shape = CircleShape2D.new()
			collision_shape.shape.radius = detection_range
		DetectionShape.RECTANGLE:
			collision_shape.shape = RectangleShape2D.new()
			collision_shape.shape.size = Vector2(detection_range * 2, detection_range * 2)

	_detection_area.add_child(collision_shape)
	actor.add_child(_detection_area)
