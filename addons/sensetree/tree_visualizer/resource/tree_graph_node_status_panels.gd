class_name TreeVisualizerGraphNodeStatusPanels
extends Resource

const CONTENT_MARGIN: int = 10

const SUCCESS_LABEL_TEXT: String = "Success"
const FAILURE_LABEL_TEXT: String = "Failure"
const RUNNING_LABEL_TEXT: String = "Running"

const SUCCESS_COLOR = Color("#18ad1a")
const FAILURE_COLOR = Color("#ad1818")
const RUNNING_COLOR = Color("#ad9318")

var SuccessIcon: Texture2D = load("res://addons/sensetree/tree_visualizer/icon/success.svg")
var FailureIcon: Texture2D = load("res://addons/sensetree/tree_visualizer/icon/failure.svg")
var RunningIcon: Texture2D = load("res://addons/sensetree/tree_visualizer/icon/running.svg")

var success_panel: Panel
var failure_panel: Panel
var running_panel: Panel


func _init():
	_initialize_status_panels()


func _initialize_status_panels() -> void:
	self.success_panel = _build_panel(SUCCESS_LABEL_TEXT, SUCCESS_COLOR, SuccessIcon)
	self.failure_panel = _build_panel(FAILURE_LABEL_TEXT, FAILURE_COLOR, FailureIcon)
	self.running_panel = _build_panel(RUNNING_LABEL_TEXT, RUNNING_COLOR, RunningIcon)


func _build_panel(label_text: String, border_color: Color, icon: Texture2D) -> Panel:
	var status_panel = Panel.new()
	status_panel.set_custom_minimum_size(Vector2(100, 30))

	var panel_stylebox = StyleBoxFlat.new()
	panel_stylebox.set_bg_color(Color(0, 0, 0, 0.5))
	status_panel.add_theme_stylebox_override("panel", panel_stylebox) 

	var margin_container = MarginContainer.new()
	SenseTreeHelpers.set_container_margins(margin_container, CONTENT_MARGIN)

	var content = HBoxContainer.new()
	content.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	margin_container.add_child(content)

	var status_icon = TextureRect.new()
	status_icon.set_texture(icon)
	content.add_child(status_icon)
	content.add_spacer(false)

	var label = Label.new()
	label.set_text(label_text)
	content.add_child(label)

	content.set_alignment(BoxContainer.AlignmentMode.ALIGNMENT_CENTER)

	status_panel.add_child(margin_container)

	return status_panel
