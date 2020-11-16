import 'package:flutter/material.dart';

import 'item.dart';
import 'test_data.dart';

class DraggableItem extends StatelessWidget {
  DraggableItem({
    Key key,
    this.width,
    this.height,
    this.scale,
    this.isDragging = false,
    this.onDragStarted,
    this.testData,
  })  : assert(testData != null),
        assert(width != null),
        assert(height != null),
        super(key: key);

  final double width;
  final double height;
  final double scale;
  final TestData testData;
  final bool isDragging;
  final VoidCallback onDragStarted;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: testData,
      feedback: Item(isDragging: true, width: width * scale, height: height * scale, testData: TestData(text: 'lala')),
      onDragStarted: onDragStarted,
      child: Item(
        width: width,
        height: height,
        testData: testData,
      ),
    );
  }
}
