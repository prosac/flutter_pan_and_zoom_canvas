import 'package:flutter/widgets.dart';

class SimpleAction {
  final IconData icon;
  final VoidCallback callback;

  SimpleAction({required this.icon, required this.callback});

  void call() {
    callback();
  }
}
