import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart'; //new line added

Future<void> showSuccessDialog(BuildContext context, String text) {
  //new method,change method name
  return QuickAlert.show(
      context: context,
      title: 'Confirmation',
      text: text,
      type: QuickAlertType.success);
}
