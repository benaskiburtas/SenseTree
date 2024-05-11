# GdUnit generated TestSuite
class_name SenseTreeBlackboardCompareValueTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const BLACKBOARD_COMPARE_VALUE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_compare_value.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var blackboard_compare_value_node: SenseTreeBlackboardCompareValueCondition
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var blackboard_compare_value_script = load(BLACKBOARD_COMPARE_VALUE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	blackboard_compare_value_node = auto_free(blackboard_compare_value_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(blackboard_compare_value_node)


func test_tick_function_when_blackboard_does_not_have_key() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_tick_function_when_blackboard_or_comparison_value_null() -> void:
	# Given
	var blackboard_key: String = "blackboard-key"
	var blackboard_value
	var comparison_value
	var expected_status = SenseTreeNode.Status.FAILURE

	#When
	blackboard_compare_value_node.blackboard_key = blackboard_key
	var result = sensetree.tick(actor, blackboard)

	#Then
	assert_bool(blackboard.has_key(blackboard_key))
	assert_that(result).is_equal(expected_status)


func test_parameterized_tick_fuction(
	blackboard_value: int,
	comparison_value: int,
	comparison_operator: SenseTreeBlackboardCompareValueCondition.ComparisonOperator,
	expected_status: SenseTreeNode.Status,
	test_parameters := [
		[
			5,
			10,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.LESS_THAN,
			SenseTreeNode.Status.SUCCESS
		],
		[
			10,
			5,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.LESS_THAN,
			SenseTreeNode.Status.FAILURE
		],
		[
			5,
			5,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.LESS_THAN_OR_EQUALS,
			SenseTreeNode.Status.SUCCESS
		],
		[
			8,
			5,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.LESS_THAN_OR_EQUALS,
			SenseTreeNode.Status.FAILURE
		],
		[
			5,
			5,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.EQUALS,
			SenseTreeNode.Status.SUCCESS
		],
		[
			12,
			7,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.EQUALS,
			SenseTreeNode.Status.FAILURE
		],
		[
			12,
			7,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.NOT_EQUALS,
			SenseTreeNode.Status.SUCCESS
		],
		[
			5,
			5,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.NOT_EQUALS,
			SenseTreeNode.Status.FAILURE
		],
		[
			8,
			8,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.GREATER_THAN_OR_EQUALS,
			SenseTreeNode.Status.SUCCESS
		],
		[
			6,
			8,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.GREATER_THAN_OR_EQUALS,
			SenseTreeNode.Status.FAILURE
		],
		[
			15,
			5,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.GREATER_THAN,
			SenseTreeNode.Status.SUCCESS
		],
		[
			5,
			15,
			SenseTreeBlackboardCompareKeysAction.ComparisonOperator.GREATER_THAN,
			SenseTreeNode.Status.FAILURE
		]
	]
) -> void:
	# Given
	var blackboard_key = "blackboard-key"

	blackboard.data[blackboard_key] = blackboard_value

	blackboard_compare_value_node.blackboard_key = blackboard_key
	blackboard_compare_value_node.comparison_value = comparison_value
	blackboard_compare_value_node.comparison_operator = comparison_operator

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeBlackboardCompareValueAction"

	# When
	var result_class_name = blackboard_compare_value_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_exported_properties() -> void:
	# Given
	var greater_than_or_equals_operator = (
		SenseTreeBlackboardCompareKeysAction.ComparisonOperator.GREATER_THAN_OR_EQUALS
	)
	var not_equals_operator = SenseTreeBlackboardCompareKeysAction.ComparisonOperator.NOT_EQUALS

	var initial_blackboard_key: String = "blackboard-key-test"
	var initial_comparison_value: String = "comparison-value-test"

	var final_blackboard_key: String = "blackboard-key-test-final"
	var final_comparison_value: String = "comparison-value-test-final"

	var expected_initial_blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", initial_blackboard_key
	)
	var expected_final_blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", final_blackboard_key
	)
	var expected_initial_comparison_value_property = SenseTreeExportedProperty.new(
		"comparison_value", "Comparison value", initial_comparison_value
	)
	var expected_final_comparison_value_property = SenseTreeExportedProperty.new(
		"comparison_value", "Comparison value", final_comparison_value
	)
	var expected_initial_comparison_operator_property = SenseTreeExportedProperty.new(
		"comparison_operator",
		"Comparison Operator",
		SenseTreeBlackboardCompareKeysAction.ComparisonOperator.keys()[not_equals_operator]
	)
	var expected_final_comparison_operator_property = SenseTreeExportedProperty.new(
		"comparison_operator",
		"Comparison Operator",
		(
			SenseTreeBlackboardCompareKeysAction
			. ComparisonOperator
			. keys()[greater_than_or_equals_operator]
		)
	)
	var expected_initial_exported_properties: Array = [
		expected_initial_blackboard_key_property,
		expected_initial_comparison_value_property,
		expected_initial_comparison_operator_property
	]
	var expected_final_exported_properties: Array = [
		expected_final_blackboard_key_property,
		expected_final_comparison_value_property,
		expected_final_comparison_operator_property
	]

	# When
	blackboard_compare_value_node.blackboard_key = "blackboard-key-test"
	blackboard_compare_value_node.comparison_value = "comparison-value-test"
	blackboard_compare_value_node.comparison_operator = not_equals_operator
	var initial_exported_properties = blackboard_compare_value_node.get_exported_properties()

	blackboard_compare_value_node.blackboard_key = "blackboard-key-test-final"
	blackboard_compare_value_node.comparison_value = "comparison-value-test-final"
	blackboard_compare_value_node.comparison_operator = greater_than_or_equals_operator
	var final_exported_properties = blackboard_compare_value_node.get_exported_properties()

	# Then
	assert_array(initial_exported_properties).contains(expected_initial_exported_properties)
	assert_array(final_exported_properties).contains(expected_final_exported_properties)
