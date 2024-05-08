# GdUnit generated TestSuite
class_name SenseTreeConditionLeafTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var condition_leaf_node: SenseTreeConditionLeaf
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var condition_leaf_script = load(CONDITION_LEAF_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	condition_leaf_node = auto_free(condition_leaf_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(condition_leaf_node)

func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeConditionLeaf"

	# When
	var result_class_name = condition_leaf_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)
