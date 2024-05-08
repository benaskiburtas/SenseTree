# GdUnit generated TestSuite
class_name SenseTreeBlackboardHasKeyTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const BLACKBOARD_HAS_KEY_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_has_key.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var has_key_blackboard_node: SenseTreeBlackboardHasKeyAction
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var has_key_blackboard_script = load(BLACKBOARD_HAS_KEY_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	has_key_blackboard_node = auto_free(has_key_blackboard_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(has_key_blackboard_node)


func test_tick_when_blackboard_does_not_have_key() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_tick_when_blackboard_has_key() -> void:
	# Given
	var blackboard_key: String = "blackboard-key"

	# When
	has_key_blackboard_node.blackboard_key = blackboard_key
	sensetree.tick(actor, blackboard)

	#Then
	assert_bool(blackboard.has_key(blackboard_key))


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeBlackboardHasKeyAction"

	# When
	var result_class_name = has_key_blackboard_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_exported_properties() -> void:
	# Given
	var initial_blackboard_key_property: String = "blackboard-key-test"
	var final_blackboard_key_property: String = "blackboard-key-test-final"

	var expected_initial_blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", initial_blackboard_key_property
	)

	var expected_final_blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", final_blackboard_key_property
	)

	# When
	has_key_blackboard_node.blackboard_key = "blackboard-key-test"
	var exported_initial_blackboard_key_property = has_key_blackboard_node.get_exported_properties()
	has_key_blackboard_node.blackboard_key = "blackboard-key-test-final"
	var exported_final_blackboard_key_property = has_key_blackboard_node.get_exported_properties()

	# Then
	assert_array(exported_initial_blackboard_key_property).contains(
		[expected_initial_blackboard_key_property]
	)
	assert_array(exported_final_blackboard_key_property).contains(
		[expected_final_blackboard_key_property]
	)
