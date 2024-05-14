# GdUnit generated TestSuite
class_name SenseTreeBlackboardCompareKeysTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const BLACKBOARD_COMPARE_KEYS_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_compare_keys.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var blackboard_compare_keys_node: SenseTreeBlackboardCompareKeysCondition
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var blackboard_compare_keys_script = load(BLACKBOARD_COMPARE_KEYS_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	blackboard_compare_keys_node = auto_free(blackboard_compare_keys_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(blackboard_compare_keys_node)


func test_tick_function_when_blackboard_or_comparison_value_is_unset() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_parameterized_tick_fuction(
	first_key_value: int,
	second_key_value: int,
	comparison_operator: SenseTreeBlackboardCompareKeysCondition.ComparisonOperator,
	expected_status: SenseTreeNode.Status,
	test_parameters := [
		[
			5,
			10,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.LESS_THAN,
			SenseTreeNode.Status.SUCCESS
		],
		[
			10,
			5,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.LESS_THAN,
			SenseTreeNode.Status.FAILURE
		],
		[
			5,
			5,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.LESS_THAN_OR_EQUALS,
			SenseTreeNode.Status.SUCCESS
		],
		[
			8,
			5,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.LESS_THAN_OR_EQUALS,
			SenseTreeNode.Status.FAILURE
		],
		[
			5,
			5,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.EQUALS,
			SenseTreeNode.Status.SUCCESS
		],
		[
			12,
			7,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.EQUALS,
			SenseTreeNode.Status.FAILURE
		],
		[
			12,
			7,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.NOT_EQUALS,
			SenseTreeNode.Status.SUCCESS
		],
		[
			5,
			5,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.NOT_EQUALS,
			SenseTreeNode.Status.FAILURE
		],
		[
			8,
			8,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.GREATER_THAN_OR_EQUALS,
			SenseTreeNode.Status.SUCCESS
		],
		[
			6,
			8,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.GREATER_THAN_OR_EQUALS,
			SenseTreeNode.Status.FAILURE
		],
		[
			15,
			5,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.GREATER_THAN,
			SenseTreeNode.Status.SUCCESS
		],
		[
			5,
			15,
			SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.GREATER_THAN,
			SenseTreeNode.Status.FAILURE
		]
	]
) -> void:
	# Given
	var first_key: Variant = "first-key-test"
	var second_key: Variant = "second-key-test"

	blackboard.data[first_key] = first_key_value
	blackboard.data[second_key] = second_key_value

	blackboard_compare_keys_node.first_blackboard_key = first_key
	blackboard_compare_keys_node.second_blackboard_key = second_key
	blackboard_compare_keys_node.comparison_operator = comparison_operator

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeBlackboardCompareKeysCondition"

	# When
	var result_class_name = blackboard_compare_keys_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_exported_properties() -> void:
	# Given
	var greater_than_or_equals_operator = (
		SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.GREATER_THAN_OR_EQUALS
	)
	var not_equals_operator = SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.NOT_EQUALS

	var initial_first_blackboard_key: String = "first-blackboard-key-test"
	var initial_second_blackboard_key: String = "second-blackboard-key-test"

	var final_first_blackboard_key: String = "first-blackboard-key-test-final"
	var final_second_blackboard_key: String = "second-blackboard-key-test-final"

	var expected_initial_first_blackboard_key_property = SenseTreeExportedProperty.new(
		"first_blackboard_key", "First blackboard key", initial_first_blackboard_key
	)
	var expected_final_first_blackboard_key_property = SenseTreeExportedProperty.new(
		"first_blackboard_key", "First blackboard key", final_first_blackboard_key
	)
	var expected_initial_second_blackboard_key_property = SenseTreeExportedProperty.new(
		"second_blackboard_key", "Second blackboard key", initial_second_blackboard_key
	)
	var expected_final_second_blackboard_key_property = SenseTreeExportedProperty.new(
		"second_blackboard_key", "Second blackboard key", final_second_blackboard_key
	)
	var expected_initial_comparison_operator_property = SenseTreeExportedProperty.new(
		"comparison_operator",
		"Comparison Operator",
		SenseTreeBlackboardCompareKeysCondition.ComparisonOperator.keys()[not_equals_operator]
	)
	var expected_final_comparison_operator_property = SenseTreeExportedProperty.new(
		"comparison_operator",
		"Comparison Operator",
		(
			SenseTreeBlackboardCompareKeysCondition
			. ComparisonOperator
			. keys()[greater_than_or_equals_operator]
		)
	)
	var expected_initial_exported_properties: Array = [
		expected_initial_first_blackboard_key_property,
		expected_initial_second_blackboard_key_property,
		expected_initial_comparison_operator_property
	]
	var expected_final_exported_properties: Array = [
		expected_final_first_blackboard_key_property,
		expected_final_second_blackboard_key_property,
		expected_final_comparison_operator_property
	]

	# When
	blackboard_compare_keys_node.first_blackboard_key = "first-blackboard-key-test"
	blackboard_compare_keys_node.second_blackboard_key = "second-blackboard-key-test"
	blackboard_compare_keys_node.comparison_operator = not_equals_operator
	var initial_exported_properties = blackboard_compare_keys_node.get_exported_properties()

	blackboard_compare_keys_node.first_blackboard_key = "first-blackboard-key-test-final"
	blackboard_compare_keys_node.second_blackboard_key = "second-blackboard-key-test-final"
	blackboard_compare_keys_node.comparison_operator = greater_than_or_equals_operator
	var final_exported_properties = blackboard_compare_keys_node.get_exported_properties()

	# Then
	assert_array(initial_exported_properties).contains(expected_initial_exported_properties)
	assert_array(final_exported_properties).contains(expected_final_exported_properties)
