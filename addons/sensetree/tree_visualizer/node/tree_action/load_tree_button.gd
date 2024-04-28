@tool
class_name TreeVisualizeLoadTreeButton
extends TreeVisualizerTreeActionButton

signal save_tree_requested

const BUTTON_TEXT: String = "Load Tree"
const MODAL_FILE_MODE: EditorFileDialog.FileMode = EditorFileDialog.FILE_MODE_OPEN_FILE
const MODAL_ACCESS_MODE: EditorFileDialog.Access = EditorFileDialog.ACCESS_RESOURCES

var _file_modal: EditorFileDialog = null


func _init() -> void:
	super()
	_initialize_button_functionality()
	_initialize_file_modal()


func _initialize_button_functionality() -> void:
	disabled = false
	self.pressed.connect(_on_button_pressed)
	text = BUTTON_TEXT


func _assign_button_state() -> void:
	disabled = false


func _assign_button_options() -> void:
	pass


func _initialize_file_modal() -> void:
	_file_modal = EditorFileDialog.new()
	_file_modal.access = MODAL_ACCESS_MODE
	_file_modal.file_mode = MODAL_FILE_MODE
	add_child(_file_modal)


func _on_button_pressed() -> void:
	print("test load tree pressed")
	_file_modal.show()
