@tool
class_name AreaDetectCondition3D
extends SenseTreeConditionLeaf

enum DetectionShape { SPHERE, BOX }

## Shape of the detection area
@export var detection_area_shape: DetectionShape
## Detection range - radius for sphere shapes, height & size for box shapes
@export var detection_range: int = 10
## Groups that should trigger the detection area
@export var groups_to_detect: Array[String] = []

var _collision_shape: CollisionShape3D


func _ready():
	_collision_shape = CollisionShape3D.new()

	if not detection_area_shape:
		push_warning("No detection area shape set for %s." % get_name())

	match detection_area_shape:
		DetectionShape.SPHERE:
			_collision_shape.shape = SphereShape3D.new()
			_collision_shape.shape.radius = detection_range
		DetectionShape.BOX:
			_collision_shape.shape = BoxShape3D.new()
			_collision_shape.shape.size = Vector3(
				detection_range * 2, detection_range * 2, detection_range * 2
			)

	self.add_child(_collision_shape)


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	if detection_area_shape == null:
		configuration_warnings.push_back("Detection area shape should be set.")
	if groups_to_detect.is_empty():
		configuration_warnings.push_back("Groups to be detected should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var colliding_bodies = _collision_shape.get_overlapping_bodies()

	for body in colliding_bodies:
		for group in groups_to_detect:
			if body.is_in_group(group):
				return Status.SUCCESS

	return Status.FAILURE
