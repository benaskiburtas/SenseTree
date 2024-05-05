# GdUnit generated TestSuite
class_name SenseTreeRandomSequenceCompositeTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const RANDOM_SEQUENCE_COMPOSITE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/composite/random_sequence.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var random_sequence_composite: SenseTreeRandomSequenceComposite
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var random_sequence_composite_script = load(RANDOM_SEQUENCE_COMPOSITE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	random_sequence_composite = auto_free(random_sequence_composite_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(random_sequence_composite)


func test_tick_child_randomization() -> void:
	# Given
	seed(50)
	var expected_structure = ".\n@Node@7\n@Node@5\n@Node@6\n@Node@8\n@Node@9\n"

	var child_mock_a = mock(SenseTreeConditionLeaf)
	var child_mock_b = mock(SenseTreeConditionLeaf)
	var child_mock_c = mock(SenseTreeConditionLeaf)
	var child_mock_d = mock(SenseTreeConditionLeaf)
	var child_mock_e = mock(SenseTreeConditionLeaf)

	do_return(SenseTreeNode.Status.FAILURE).on(child_mock_a).tick(actor, blackboard)
	do_return(SenseTreeNode.Status.FAILURE).on(child_mock_b).tick(actor, blackboard)
	do_return(SenseTreeNode.Status.FAILURE).on(child_mock_c).tick(actor, blackboard)
	do_return(SenseTreeNode.Status.FAILURE).on(child_mock_d).tick(actor, blackboard)
	do_return(SenseTreeNode.Status.FAILURE).on(child_mock_e).tick(actor, blackboard)

	random_sequence_composite.add_child(child_mock_a)
	random_sequence_composite.add_child(child_mock_b)
	random_sequence_composite.add_child(child_mock_c)
	random_sequence_composite.add_child(child_mock_d)
	random_sequence_composite.add_child(child_mock_e)

	# When
	sensetree.tick(actor, blackboard)

	# Then
	var result_structure = random_sequence_composite.get_tree_string()
	assert_str(result_structure).is_equal(expected_structure)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeRandomSequenceComposite"

	# When
	var result_class_name = random_sequence_composite.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)
