import 'dart:async';

class TimerBloc {
  final _controller = StreamController<CountDownTimer>();

  Stream<CountDownTimer> get timer => _controller.stream;
  final _actionController = StreamController<TimerAction>();

  Sink<TimerAction> get timerAction => _actionController.sink;

  CountDownTimer countDownTimer;

  TimerBloc(Duration timeLimit) {
    countDownTimer = CountDownTimer(timeLimit);
    countDownTimer.update.listen(_controller.add); // TODO もう少しスッキリかけるはず
    _actionController.stream.listen((data) {
      countDownTimer.actionHandle(data).pipe(_controller);
    });
  }

  void dispose() {
    _controller.close();
    _actionController.close();
  }
}



class CountDownTimer {
  StreamController<CountDownTimer> _updateController;
  Stream<CountDownTimer> get update => _updateController.stream;

  TimerState _timerState = TimerState.STOP;

  TimerState get timerState => _timerState;
  Duration _timeLimit;
  Duration _diff;

  Duration get diff => _diff;
  Timer _timer;
  int _counter = 0;
  static final Duration _countUpDuration = new Duration(milliseconds: 100);

  CountDownTimer(Duration timeLimit, [Function(CountDownTimer) listener]) {
    _timeLimit = timeLimit;
    _diff = _timeLimit;
    //_updateController = StreamController(onListen: (){listener(this);});
    _updateController = StreamController();
  }

  Stream<CountDownTimer> actionHandle(TimerAction action) {
    switch (action) {
      case TimerAction.START:
        _start();
        break;
      case TimerAction.STOP:
        _stop();
        break;
      case TimerAction.RESET:
        _reset();
        break;
    }
  }

  void _start() {
    _timerState = TimerState.START;
    _timer = Timer.periodic(_countUpDuration, _tick);
  }

  void _reset() {
    _counter = 0;
    _timerState = TimerState.STOP;
    _timer?.cancel();
    _updateController.sink.add(this);
  }

  void _stop() {
    _timerState = TimerState.STOP;
    _timer?.cancel();
    _updateController.sink.add(this);
  }

  int _convertCounterToMilliseconds() =>
      _counter * _countUpDuration.inMilliseconds;

  void _tick(Timer timer) {
    _counter++;
    _diff =
        _timeLimit - Duration(milliseconds: _convertCounterToMilliseconds());
    if (_timeLimit.inMilliseconds <= _convertCounterToMilliseconds()) {
      _timerState = TimerState.TIME_UP;
    }
    _updateController.sink.add(this);
  }
}

enum TimerState { START, STOP, TIME_UP }

enum TimerAction { START, STOP, RESET }
