# GdUnit generated TestSuite
class_name SenseTreeRetryBlackboardAssignValueTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const BLACKBOARD_ASSIGN_VALUE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_assign_value.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var assign_value_blackboard_node: SenseTreeBlackboardAssignValueAction
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var assign_value_blackboard_script = load(BLACKBOARD_ASSIGN_VALUE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	assign_value_blackboard_node = auto_free(assign_value_blackboard_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(assign_value_blackboard_node)


func test_tick_fuction() -> void:
	# Given
	blackboard.data.clear()
	var blackboard_key: String = "blackboard-key"
	var blackboard_value = "final_value"

	# When
	assign_value_blackboard_node.blackboard_key = blackboard_key
	assign_value_blackboard_node.key_value = blackboard_value
	sensetree.tick(actor, blackboard)

	# Then
	assert_bool(blackboard.has_key(blackboard_key))
	assert_that(blackboard.data[blackboard_key]).is_equal(blackboard_value)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeBlackboardAssignValueAction"

	# When
	var result_class_name = assign_value_blackboard_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_exported_properties() -> void:
	# Given
	var initial_blackboard_key_property: String = "blackboard-key-test"
	var initial_key_value_property: String = "key_value-test"
	var final_blackboard_key_property: String = "blackboard-key-test-final"
	var final_key_value_property: String = "key_value-test-final"

	var expected_initial_blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", initial_blackboard_key_property
	)

	var expected_final_blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", final_blackboard_key_property
	)

	var expected_initial_key_value_property = SenseTreeExportedProperty.new(
		"key_value", "Key value", initial_key_value_property
	)

	var expected_final_key_value_property = SenseTreeExportedProperty.new(
		"key_value", "Key value", final_key_value_property
	)
	var expected_initial_exported_properties: Array = [
		expected_initial_blackboard_key_property, expected_initial_key_value_property
	]
	var expected_final_exported_properties: Array = [
		expected_final_blackboard_key_property, expected_final_key_value_property
	]

	# When
	assign_value_blackboard_node.blackboard_key = "blackboard-key-test"
	assign_value_blackboard_node.key_value = "key_value-test"
	var initial_exported_properties = assign_value_blackboard_node.get_exported_properties()

	assign_value_blackboard_node.blackboard_key = "blackboard-key-test-final"
	assign_value_blackboard_node.key_value = "key_value-test-final"
	var final_exported_properties = assign_value_blackboard_node.get_exported_properties()

	# Then
	assert_array(initial_exported_properties).contains(expected_initial_exported_properties)
	assert_array(final_exported_properties).contains(expected_final_exported_properties)
