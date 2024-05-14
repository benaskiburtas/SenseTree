@tool
@icon("res://addons/sensetree/behavior_tree/icon/Retry.svg")
class_name SenseTreePostponeDecorator
extends SenseTreeNode

enum TimerStatus { STOPPED, RUNNING, FINISHED }

## Delays actual SUCCESS/FAILURE result by this many seconds, during this period, returns SUCCESS.
@export var timer_duration: float = 5.0

var _timer: Timer

var _tick_result: Status
var _timer_status: TimerStatus = TimerStatus.STOPPED
var _actor: Node
var _blackboard: SenseTreeBlackboard


func _init() -> void:
	_timer = Timer.new()
	_timer.autostart = false
	_timer.one_shot = true
	add_child(_timer, false, Node.INTERNAL_MODE_BACK)


func _ready() -> void:
	_timer.connect("timeout", _on_timer_timeout)


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	match _timer_status:
		TimerStatus.FINISHED:
			var result_to_return = _tick_result
			# Clear for next ticks
			_timer_status = TimerStatus.STOPPED
			return result_to_return
		TimerStatus.RUNNING:
			return Status.SUCCESS
		TimerStatus.STOPPED:
			if has_children():
				_actor = actor
				_blackboard = blackboard
			_timer.start(timer_duration)
			_timer_status = TimerStatus.RUNNING
			return Status.RUNNING
	return Status.FAILURE


func _on_timer_timeout() -> void:
	if _actor and _blackboard:
		_tick_result = get_child(0).tick(_actor, _blackboard)
	else:
		_tick_result = Status.SUCCESS
	_timer_status = TimerStatus.FINISHED
