import 'package:flutter/cupertino.dart';

import '../../lib/model/connection.dart';
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
  test('it is initialized with two nodes', () {
    expect(Connection(Node(SomeWidget(key: UniqueKey())), Node(SomeWidget(key: UniqueKey(),))), isA<Connection>());
  });
}
