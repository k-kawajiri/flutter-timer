import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Duration> showTimerDialog({
  @required BuildContext context,
  TransitionBuilder builder,
  bool useRootNavigator = true,
}) {
  final Widget dialog = _TimerDialog();
  return showDialog(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}

class _TimerDialog extends StatefulWidget {
  @override
  State createState() => _TimerDialogState();
}

class _TimerDialogState extends State<_TimerDialog> {
  final dateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> actions = [
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
    ];
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
      actions: actions,
    );

    return dialog;
  }

  @override
  void dispose() {
    dateTextController.dispose();
    super.dispose();
  }
}
