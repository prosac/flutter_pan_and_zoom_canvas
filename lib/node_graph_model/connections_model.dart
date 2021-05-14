
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pan_and_zoom/draggable_item.dart';

class Connection {
  GlobalKey fromKey;
  GlobalKey toKey;

  Connection(fromKey, toKey) {
    this.fromKey = fromKey;
    this.toKey = toKey;
  }
}

class DrawingProcedure {
  Widget fromWidget;
  Widget toWidget;

  DrawingProcedure(Widget fromWidget) {
    this.fromWidget = fromWidget;
  }

  void finishDrawing(Widget toWidget) {
    this.toWidget = toWidget;
  }
}

class ConnectionsModel with ChangeNotifier {
  final List<Connection> _connections = [];
  DrawingProcedure _drawingProcedure;

  String mode() {
    if(_drawingProcedure != null) {
      return 'Drawing in progress';
    } else {
      return 'Not drawing';
    }
  }

  void startDrawing(Widget fromWidget) {
    print('started drawing');
    _drawingProcedure = DrawingProcedure(fromWidget);
  }

  Offset startOffset() {
    // final RenderBox renderBox = _drawingProcedure.fromWidget
    // final offset = renderBox.localToGlobal(Offset.zero);
    // final RenderBox renderBox = context.findRenderObject();
    // final offset = renderBox.localToGlobal(Offset.zero);
    return (_drawingProcedure.fromWidget as DraggableItem).currentOffset();
  }

  void finishDrawing(Widget toWidget) {
    _drawingProcedure.finishDrawing(toWidget);
    add(Connection(_drawingProcedure.fromWidget.key, _drawingProcedure.toWidget.key));
    _drawingProcedure = null;
  }

  void add(Connection connection) {
    _connections.add(connection);
    notifyListeners();
  }

  void remove(Connection connection) {
    _connections.remove(connection);
    notifyListeners();
  }

  void clear() {
    _connections.clear();
    notifyListeners();
  }

  get connections => _connections;
}