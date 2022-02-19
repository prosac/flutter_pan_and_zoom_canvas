import 'package:flutter/widgets.dart';

class Node {
  Node(this._widget);

  Widget _widget;

  get key => _widget.key;
}
