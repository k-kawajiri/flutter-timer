import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimerBloc {
  final _controller = StreamController<CountDownTimerInfo>();

  Stream<CountDownTimerInfo> get timer => _controller.stream;
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

  void dispose() async {
    _controller.close();
    _actionController.close();
  }
}

class TimerBloc2 extends CountDownTimerInfo {
  StreamController<CountDownTimerInfo> _controller;
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

  TimerBloc2(Duration timeLimit) {
    _controller  = StreamController<CountDownTimerInfo>(
      onListen:listen,
    );
    _counter = 0;
    _timeUp = timeLimit;
    _diffByTimeUp = _timeUp;
    _actionController.stream.listen((data) {
      actionHandle(data);
    });
//    timer.listen((data){
//      debugPrint(data.diffByTimeUp.toString());
//    });
  }

  void listen(){
    debugPrint("listent");
  }

  void dispose() async {
    _controller.close();
    _actionController.close();
  }

  void actionHandle(TimerAction action) {
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
    _controller.sink.add(this);
  }

  void _stop() {
    _timerState = TimerState.STOP;
    _timer?.cancel();
    _controller.sink.add(this);
  }

  int _convertCounterToMilliseconds() =>
      _counter * _countUpDuration.inMilliseconds;

  void _tick(Timer timer) {
    _counter++;
    _diffByTimeUp =
        _timeUp - Duration(milliseconds: _convertCounterToMilliseconds());
    if (_timeUp.inMilliseconds <= _convertCounterToMilliseconds()) {
      _timerState = TimerState.TIME_UP;
    }
    _controller.sink.add(this);
  }
}

abstract class CountDownTimerInfo {
  /// タイマーの状態
  TimerState get timerState;

  /// タイムアップまでの時間
  Duration get diffByTimeUp;

  /// タイムアップ時間
  Duration get timeUp;
}

class CountDownTimer extends CountDownTimerInfo {
  StreamController<CountDownTimer> _updateController;

  Stream<CountDownTimer> get update => _updateController.stream;

  TimerState _timerState = TimerState.STOP;

  TimerState get timerState => _timerState;
  Duration _timeUp;

  Duration get timeUp => _timeUp;
  Duration _diffByTimeUp;

  Duration get diffByTimeUp => _diffByTimeUp;
  Timer _timer;
  int _counter = 0;
  static final Duration _countUpDuration = new Duration(milliseconds: 100);

  CountDownTimer(Duration timeLimit) {
    _timeUp = timeLimit;
    _diffByTimeUp = _timeUp;
    //_updateController = StreamController(onListen: (){listener(this);});
    _updateController = StreamController();
  }

  Stream<CountDownTimerInfo> actionHandle(TimerAction action) {
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
    _diffByTimeUp =
        _timeUp - Duration(milliseconds: _convertCounterToMilliseconds());
    if (_timeUp.inMilliseconds <= _convertCounterToMilliseconds()) {
      _timerState = TimerState.TIME_UP;
    }
    _updateController.sink.add(this);
  }
}

enum TimerState { START, STOP, TIME_UP }

enum TimerAction { START, STOP, RESET }
