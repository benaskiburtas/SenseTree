# GdUnit generated TestSuite
class_name SenseTreeActionLeafTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const ACTION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/action.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var action_leaf_node: SenseTreeActionLeaf
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var action_leaf_script = load(ACTION_LEAF_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	action_leaf_node = auto_free(action_leaf_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(action_leaf_node)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeActionLeaf"

	# When
	var result_class_name = action_leaf_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)
