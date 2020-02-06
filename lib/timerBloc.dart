import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';

class TimerBloc extends CountDownTimerInfo {
  StreamController<CountDownTimerInfo> _controller = BehaviorSubject();

  Stream<CountDownTimerInfo> get timer => _controller.stream;
  final _actionController = StreamController<TimerAction>();

  Sink<TimerAction> get timerAction => _actionController.sink;

  TimerState _timerState = TimerState.STOP;

  TimerState get timerState => _timerState;
  Duration _timeUp;

  Duration get timeUp => _timeUp;
  Duration _diffByTimeUp;

  Duration get diffByTimeUp => _diffByTimeUp;
  Timer _timer;
  int _counter;
  static final Duration _countUpDuration = new Duration(milliseconds: 100);

  TimerBloc(Duration timeLimit) {
    _counter = 0;
    _timeUp = timeLimit;
    _diffByTimeUp = _timeUp;
    _actionController.stream.listen((data) {
      actionHandle(data);
    });
  }

  void listen() {
    debugPrint("listent");
  }

  void dispose() async {
    _controller.close();
    _actionController.close();
  }

  void actionHandle(TimerAction action) {
    switch (action) {
      case TimerAction.TOGGLE_START_STOP:
        if (timerState == TimerState.STOP) {
          _start();
        } else {
          _stop();
        }
        break;
      case TimerAction.RESET:
        _reset();
        break;
    }
  }

  void _start() {
    _timerState = TimerState.START;
    _timer ??= Timer.periodic(_countUpDuration, _tick);
  }

  void _reset() {
    _counter = 0;
    _calcDiffByTimeUp();
    _stop();
  }

  void _stop() {
    _timerState = TimerState.STOP;
    _timer?.cancel();
    _timer = null;
    _controller.sink.add(this);
  }

  void _tick(Timer timer) {
    _counter++;
    _calcDiffByTimeUp();
    if (_timeUp.inMilliseconds <= _convertCounterToMilliseconds()) {
      _timerState = TimerState.TIME_UP;
    }
    _controller.sink.add(this);
  }

  void _calcDiffByTimeUp() => _diffByTimeUp =
      _timeUp - Duration(milliseconds: _convertCounterToMilliseconds());

  int _convertCounterToMilliseconds() =>
      _counter * _countUpDuration.inMilliseconds;
}

abstract class CountDownTimerInfo {
  /// タイマーの状態
  TimerState get timerState;

  /// タイムアップまでの時間
  Duration get diffByTimeUp;

  /// タイムアップ時間
  Duration get timeUp;
}

enum TimerState { START, STOP, TIME_UP }

enum TimerAction { TOGGLE_START_STOP, RESET }
