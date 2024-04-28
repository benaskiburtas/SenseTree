@tool
class_name TreeVisualizeNewTreeButton
extends TreeVisualizerTreeActionButton

const BUTTON_TEXT = "New Tree"


func _init() -> void:
	super()
	disabled = false
	text = BUTTON_TEXT


func _assign_button_state() -> void:
	pass


func _assign_button_options() -> void:
	pass

func _on_button_pressed() -> void:
	print("test")
