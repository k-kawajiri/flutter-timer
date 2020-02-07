import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Duration> showTimerPicker({
  @required BuildContext context,
  TransitionBuilder builder,
  bool useRootNavigator = true,
}) async {
  final Widget dialog = _TimerPicker();
  return await showDialog(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}

class _TimerPicker extends StatefulWidget {
  @override
  State createState() => _TimerPickerState();
}

class _TimerPickerState extends State<_TimerPicker> {
  final dateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final Widget actions = ButtonBar(
      children: <Widget>[
        FlatButton(
          child: Text(localizations.cancelButtonLabel),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text(localizations.okButtonLabel),
          onPressed: () {
            // TODO バリデーション
            int seconds = int.tryParse(dateTextController.text);
            Navigator.pop<Duration>(context, Duration(seconds: seconds));
          },
        ),
      ],
    );
    final AlertDialog dialog = AlertDialog(
      title: Text("Set Timer"),
      content: TextField(
        controller: dateTextController,
        decoration: InputDecoration(
          hintText: "sec",
        ),
        autofocus: true,
        keyboardType: TextInputType.number,
      ),
      actions: [actions],
    );

    return Theme(
      data: Theme.of(context),
      child: dialog,
    );
  }

  @override
  void dispose() {
    dateTextController.dispose();
    super.dispose();
  }
}
