@tool
@icon("res://addons/sensetree/behavior_tree/icon/Retry.svg")
class_name SenseTreeTimedDecorator
extends SenseTreeNode

## Delays actual SUCCESS/FAILURE result by this many seconds, during this period, returns SUCCESS.
@export var timer_duration: float = 5.0

var _has_result: bool = false
var _has_timer_ended: bool = false

var _tick_result: Status

var _timer: Timer

func _init() -> void:
	_timer = Timer.new()
	_timer.autostart = false
	_timer.one_shot = true
	add_child(_timer, false, Node.INTERNAL_MODE_BACK)

func _ready() -> void:
	_timer.connect("timeout", _on_timer_timeout)

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	print(_timer.time_left)
	if not _has_result:
		_has_result = true
		if not has_children():
			_tick_result = Status.SUCCESS
			_timer.start(timer_duration)
		else:
			_tick_result = get_child(0).tick(actor, blackboard)
			_timer.start(timer_duration)

	if _has_timer_ended:
		var result_to_return = _tick_result
		# Clear for next ticks
		_has_result = false
		_has_timer_ended = false
		return result_to_return

	return Status.SUCCESS

func _on_timer_timeout() -> void:
	_has_timer_ended = true
