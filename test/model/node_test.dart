import 'package:flutter/cupertino.dart';
import '../../lib/model/node.dart';
import 'package:test/test.dart';

class SomeWidget extends StatelessWidget {
  SomeWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Doesntmatter');
  }
}

void main() {
  test('it is initialized with a widget', () {
    var node = Node(SomeWidget(key: UniqueKey()));
    expect(node, isA<Node>());
  });

  test('key is delegated to the inner widget', () {
    var key = UniqueKey();
    var node = Node(SomeWidget(key: key));
    expect(node.key, equals(key));
  });
}
