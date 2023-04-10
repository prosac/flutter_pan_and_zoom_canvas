import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/commands/add_thing_from_existing.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/model/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:flutter_pan_and_zoom/plain_text_file_presentation.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:flutter_pan_and_zoom/utils/random.dart';
import 'package:provider/provider.dart';

void addPlainTextFile(offset, BuildContext context) async {
  final newNode = Node(offset: offset, payload: TestData(text: 'Some other Payload'));
  final model = context.read<GraphModel>();

  PlainTextFile file = await PlainTextFile.asyncNew(randomString(10));

  newNode.presentation =
      PlainTextFilePresentation(node: newNode, file: file, onAddPressed: () => addThingFromExisting(newNode, context));

  model.add(newNode);
  context.read<ViewerState>().exitSpaceCommandMode();
}
