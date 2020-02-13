import 'package:flutter/material.dart';
import 'package:flutter_timer/time_formatter.dart';
import 'package:flutter_timer/timer_bloc.dart';
import 'package:flutter_timer/timer_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'カウントダウンタイマー'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  final CountDownTimerBloc timerBloc = new CountDownTimerBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              tooltip: "Set Timer",
              onPressed: () {
                Future date;
                date = showTimerPicker(context: context);
                date.then((value) => timerBloc.setting.add(value));
              },
              icon: Icon(Icons.access_time),
            ),
            StreamBuilder(
                initialData: timerBloc,
                stream: timerBloc.timer,
                builder: (BuildContext context,
                    AsyncSnapshot<CountDownTimerInfo> snapShot) {
                  return Text(
                    TimeFormatter.formatToHMSColon(snapShot.data.remainingTime),
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 2.0),
                  );
                }),
            IconButton(
              tooltip: "Reset",
              onPressed: () => timerBloc.timerAction.add(TimerAction.RESET),
              icon: Icon(Icons.restore),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            timerBloc.timerAction.add(TimerAction.TOGGLE_START_STOP);
          },
          child: StreamBuilder(
              initialData: null,
              stream: timerBloc.timer,
              builder: (BuildContext context,
                  AsyncSnapshot<CountDownTimerInfo> snapShot) {
                Icon icon;
                switch (snapShot?.data?.timerState) {
                  case TimerState.START:
                    icon = Icon(Icons.pause);
                    break;
                  case TimerState.TIME_UP:
                    icon = Icon(Icons.stop);
                    break;
                  case TimerState.STOP:
                  default:
                    icon = Icon(Icons.play_arrow);
                }
                return icon;
              })),
    );
  }
}
