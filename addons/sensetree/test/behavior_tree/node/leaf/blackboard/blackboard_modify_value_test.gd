# GdUnit generated TestSuite
class_name SenseTreeBlackboardModifyValueTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const BLACKBOARD_MODIFY_VALUE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_modify_value.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var modify_value_blackboard_node: SenseTreeBlackboardModifyValueAction
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var modify_value_blackboard_script = load(BLACKBOARD_MODIFY_VALUE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	modify_value_blackboard_node = auto_free(modify_value_blackboard_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(modify_value_blackboard_node)


func test_tick_when_blackboard_key_or_its_value_is_missing() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_tick_when_modification_key_or_its_value_is_missing() -> void:
	# Given
	var blackboard_key: String = "blackboard-key"
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	modify_value_blackboard_node.blackboard_key = blackboard_key
	var result = sensetree.tick(actor, blackboard)

	#Then
	assert_that(result).is_equal(expected_status)


func test_tick_when_modification_value_equals_null() -> void:
	# Given
	var blackboard_key: String = "blackboard-key"
	var modification_value: String = "modification-value"
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	modify_value_blackboard_node.blackboard_key = blackboard_key
	modify_value_blackboard_node.modification_value = modification_value
	var result = sensetree.tick(actor, blackboard)

	#Then
	assert_that(result).is_equal(expected_status)


func test_tick_when_unable_to_validate_and_parse_expression() -> void:
	# Given
	var blackboard_key: String = "blackboard-key"
	var modification_value: String = "modification-value"
	var expected_status = SenseTreeNode.Status.FAILURE
	var blackboard_value: String = "blackboard-value"
	blackboard.data[blackboard_key] = blackboard_value

	# When
	modify_value_blackboard_node.blackboard_key = blackboard_key
	modify_value_blackboard_node.modification_value = modification_value
	var result = sensetree.tick(actor, blackboard)

	#Then
	assert_that(result).is_equal(expected_status)


func test_parameterized_tick_fuction(
	initial_key_value: String,
	modification_value: String,
	expected_final_value: String,
	modification_operator: SenseTreeBlackboardModifyValueAction.ModificationOperator,
	expected_status: SenseTreeNode.Status,
	test_parameters := [
		[
			"5",
			"10",
			"15",
			SenseTreeBlackboardModifyValueAction.ModificationOperator.ADD,
			SenseTreeNode.Status.SUCCESS
		],
		[
			"75",
			"4.6",
			"70.4",
			SenseTreeBlackboardModifyValueAction.ModificationOperator.SUBTRACT,
			SenseTreeNode.Status.SUCCESS
		],
		[
			"2.2",
			"5",
			"11",
			SenseTreeBlackboardModifyValueAction.ModificationOperator.MULTIPLY,
			SenseTreeNode.Status.SUCCESS
		],
		[
			"30",
			"3",
			"10",
			SenseTreeBlackboardModifyValueAction.ModificationOperator.DIVIDE,
			SenseTreeNode.Status.SUCCESS
		],
		[
			"2",
			"3",
			"8",
			SenseTreeBlackboardModifyValueAction.ModificationOperator.EXPONENTIATION,
			SenseTreeNode.Status.SUCCESS
		],
	]
) -> void:
	# Given
	var blackboard_key: String = "blackboard-key"
	blackboard.data[blackboard_key] = initial_key_value
	modify_value_blackboard_node.blackboard_key = blackboard_key
	modify_value_blackboard_node.modification_value = modification_value
	modify_value_blackboard_node.modification_operator = modification_operator

	# When
	var actual_status = sensetree.tick(actor, blackboard)

	# Then
	var actual_final_value = blackboard.data[blackboard_key]
	assert_that(actual_status).is_equal(expected_status)
	assert_that(actual_final_value).is_equal(expected_final_value)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeBlackboardModifyValueAction"

	# When
	var result_class_name = modify_value_blackboard_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_exported_properties() -> void:
	# Given
	var divide_operator = SenseTreeBlackboardModifyValueAction.ModificationOperator.DIVIDE
	var exponentiation_operator = (
		SenseTreeBlackboardModifyValueAction.ModificationOperator.EXPONENTIATION
	)

	var initial_blackboard_key: String = "blackboard-key-test"
	var initial_modification_value: String = "modification-value-test"

	var final_blackboard_key: String = "blackboard-key-test-final"
	var final_modificationn_value: String = "modification-value-test-final"

	var expected_initial_blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", initial_blackboard_key
	)
	var expected_final_blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", final_blackboard_key
	)
	var expected_initial_modification_value_property = SenseTreeExportedProperty.new(
		"modification_value", "Modification value", initial_modification_value
	)
	var expected_final_modification_value_property = SenseTreeExportedProperty.new(
		"modification_value", "Modification value", final_modificationn_value
	)
	var expected_initial_modification_operator_property = SenseTreeExportedProperty.new(
		"modification_operator",
		"Modification Opeartor",
		SenseTreeBlackboardModifyValueAction.ModificationOperator.keys()[divide_operator]
	)
	var expected_final_modification_operator_property = SenseTreeExportedProperty.new(
		"modification_operator",
		"Modification Opeartor",
		SenseTreeBlackboardModifyValueAction.ModificationOperator.keys()[exponentiation_operator]
	)
	var expected_initial_exported_properties: Array = [
		expected_initial_blackboard_key_property,
		expected_initial_modification_value_property,
		expected_initial_modification_operator_property
	]
	var expected_final_exported_properties: Array = [
		expected_final_blackboard_key_property,
		expected_final_modification_value_property,
		expected_final_modification_operator_property
	]

	# When
	modify_value_blackboard_node.blackboard_key = "blackboard-key-test"
	modify_value_blackboard_node.modification_value = "modification-value-test"
	modify_value_blackboard_node.modification_operator = divide_operator
	var initial_exported_properties = modify_value_blackboard_node.get_exported_properties()

	modify_value_blackboard_node.blackboard_key = "blackboard-key-test-final"
	modify_value_blackboard_node.modification_value = "modification-value-test-final"
	modify_value_blackboard_node.modification_operator = exponentiation_operator
	var final_exported_properties = modify_value_blackboard_node.get_exported_properties()

	# Then
	assert_array(initial_exported_properties).contains(expected_initial_exported_properties)
	assert_array(final_exported_properties).contains(expected_final_exported_properties)
