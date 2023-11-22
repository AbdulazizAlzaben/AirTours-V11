import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart'; //new line

Future<void> showErrorDialog(BuildContext context, String text) {
  //new method
  return QuickAlert.show(
      context: context,
      title: 'Error occurred',
      text: text,
      type: QuickAlertType.error);
}
