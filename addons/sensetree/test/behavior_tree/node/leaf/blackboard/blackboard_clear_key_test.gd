# GdUnit generated TestSuite
class_name SenseTreeBlackboardClearKeyTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const BLACKBOARD_CLEAR_KEY_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_clear_key.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var clear_key_blackboard_node: SenseTreeBlackboardClearKeyAction
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var clear_key_blackboard_script = load(BLACKBOARD_CLEAR_KEY_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	clear_key_blackboard_node = auto_free(clear_key_blackboard_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(clear_key_blackboard_node)


func test_tick_fuction() -> void:
	# Given
	var blackboard_key: String = "blackboard-key"

	# When
	clear_key_blackboard_node.blackboard_key = blackboard_key
	sensetree.tick(actor, blackboard)

	# Then
	assert_that(blackboard.data).is_null

func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeBlackboardClearKeyAction"

	# When
	var result_class_name = clear_key_blackboard_node.get_sensenode_class()

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
	clear_key_blackboard_node.blackboard_key = "blackboard-key-test"
	var exported_initial_blackboard_key_property = clear_key_blackboard_node.get_exported_properties()
	clear_key_blackboard_node.blackboard_key = "blackboard-key-test-final"
	var exported_final_blackboard_key_property = clear_key_blackboard_node.get_exported_properties()

	# Then
	assert_array(exported_initial_blackboard_key_property).contains(
		[expected_initial_blackboard_key_property]
	)
	assert_array(exported_final_blackboard_key_property).contains(
		[expected_final_blackboard_key_property]
	)
