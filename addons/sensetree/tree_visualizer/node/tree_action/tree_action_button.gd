@tool
class_name TreeVisualizerTreeActionButton
extends Button


func _init():
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	disabled = true


func _assign_button_state() -> void:
	pass


func _assign_button_options() -> void:
	pass
