import 'package:flutter/material.dart';

import 'example_content_2.dart';
import 'test_data.dart';

class Item extends StatelessWidget {
  Item({Key key, this.isDragging = false, this.testData, this.width, this.height})
      : assert(testData != null),
        assert(width != null),
        assert(height != null),
        super(key: key);

  final bool isDragging;
  final TestData testData;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExampleContent2(label: testData.text, itemColor: Colors.deepPurpleAccent),
      width: width, height: height
    );
  }
}
