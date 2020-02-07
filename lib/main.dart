import 'package:flutter/material.dart';
import 'package:flutter_timer/timerBloc.dart';
import 'package:flutter_timer/timer_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'カウントダウンタイマー'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final CountDownTimerBloc timerBloc = new CountDownTimerBloc();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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
                    snapShot.data.remainingTime,
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
              })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TimerWidget extends StatefulWidget {
  final String title;

  TimerWidget({Key key, this.title}) : super(key: key);

  @override
  State createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  final CountDownTimerBloc timerBloc = new CountDownTimerBloc();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () => {},
              icon: Icon(Icons.access_time),
            ),
            StreamBuilder(
                initialData: timerBloc,
                stream: timerBloc.timer,
                builder: (BuildContext context,
                    AsyncSnapshot<CountDownTimerInfo> snapShot) {
                  return Text(snapShot.data.remainingTime.toString());
                }),
            IconButton(
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
                    icon = Icon(Icons.pause_circle_outline);
                    break;
                  case TimerState.TIME_UP:
                    icon = Icon(Icons.stop);
                    break;
                  case TimerState.STOP:
                  default:
                    icon = Icon(Icons.play_circle_outline);
                }
                return icon;
              })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    timerBloc.dispose();
    super.dispose();
  }
}
