import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(dynamic context, String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
